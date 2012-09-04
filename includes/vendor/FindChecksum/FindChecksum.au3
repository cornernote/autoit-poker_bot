; ===================================================================================
; _findchecksum UDF v1 - June 24, 2007
; Written by Andy Flesner
; ===================================================================================
#cs
Syntax is as follows: _findchecksum($checksum, $width, $height, $pcolor, $x = 0, $y = 0, $d_width = @DesktopWidth, $d_height = @DesktopHeight)

$checksum - the checksum to search for
$width - the width of the checksum area
$height - the height of the checksum area
$pcolor - the pixel color of the top left pixel of the checksum object
$x - the starting x coordinate
$y - the starting y coordinate
$D_Width - Width of the total search area, default is desktop resolution width
$D_Height - Height of the total search area, default is desktop resolution height

The function returns the x and y coordinates of the upper left corner where the checksum
is found as an array.  For Example:

	$coordinates = _findchecksum($checksum, $width, $height, $pcolor)

The x coordinate would be $coordinates[0] and the y coordinate would be $coordinates[1].

If the coordinates are not found, the function will return a value of 0.
#ce
; ===================================================================================

Func _FindChecksum($checksum, $width, $height, $pcolor, $x = 0, $y = 0, $d_width = @DesktopWidth, $d_height = @DesktopHeight)
    $current_y = $d_height - 1
    While 1
        $xy = PixelSearch($x, $y, $d_width - 1, $current_y, $pcolor)
        If @error And $current_y = ($d_height - 1) Then
            Return 0
        ElseIf @error Then
            $x = 0
			$y = $current_y + 1
            $current_y = ($d_height - 1)
        ElseIf $checksum = PixelCheckSum($xy[0], $xy[1], $xy[0] + $width, $xy[1] + $height) Then
            Return $xy
        Else
            $x = $xy[0] + 1
			$y = $xy[1]
			$current_y = $y
        EndIf
    WEnd
EndFunc