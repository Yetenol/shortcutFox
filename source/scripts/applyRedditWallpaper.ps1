param(
    $Subreddit = "wallpaper",
    $SaveWallpaperTo = ".\Wallpaper\Reddit",
    $DateFormat = "yyyy-MM-dd"
)

$env:Pictures = (New-Object -ComObject Shell.Application).NameSpace('shell:My Pictures').Self.Path
Set-Location $env:Pictures
New-Item -Path $SaveWallpaperTo -ItemType Directory -ErrorAction Ignore
Set-Location $SaveWallpaperTo -ErrorAction Stop

$reddit_api_reply = Invoke-WebRequest "https://www.reddit.com/r/$Subreddit/.json"
$json = ConvertFrom-Json $reddit_api_reply.content
$posts = $json.data.children.data
$first_media_post = $posts | where is_reddit_media_domain | select -First 1
$image_url = $first_media_post.url
$image_extension = [IO.Path]::GetExtension($image_url)
$image_raw_title = $first_media_post.title
$image_title_without_dimensions = $image_raw_title -replace "\s*[\[\(]?\d+\s*[×x]\s*\d+[\]\)]?\s*", ""
$image_title_without_square_brackets = $image_title_without_dimensions -replace "\[", "(" -replace "\]", ")"

$date = [DateTime]::Now.ToString($DateFormat)
$filename = @($date, $image_title_without_square_brackets) -join " "
$filename += $image_extension

$does_file_exists = Test-Path $filename
if ($does_file_exists) {
    Write-Output "Image already exists"
} else {
    $escaped_path = [WildcardPattern]::Escape($filename)
    Invoke-WebRequest $image_url -OutFile $escaped_path -ErrorAction Stop
}

$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc

$wallpaper_file = Resolve-Path $filename | select -expand Path
[Wallpaper]::SetWallpaper($wallpaper_file)

Write-Output "Applied $filename"