Strict

Public

' Imports:
Import matrix2d

Import polygon

' Functions:

' The 'HandleX' and 'HandleY' arguments are in real units; they are not ranges.
Function RectangleToSurface:Void(M:Matrix2D, Rect:Rect, PositionX:Float, PositionY:Float, Width:Float, Height:Float, Rotation:Float=0.0, HandleX:Float=0.0, HandleY:Float=0.0, ScaleX:Float=1.0, ScaleY:Float=1.0)
	Rect.InitRect(0.0, 0.0, Width, Height)
	
	RotatePolygon(M, Rect, Rotation, ScaleX, ScaleY, HandleX, HandleY, False)
	
	M.Translate(PositionX, PositionY)
	
	TransformPoints(M, Rect)
	
	Return
End

Function RotatePolygonAroundCenter:Void(M:Matrix2D, P:Polygon, Angle:Float, TransformAfter:Bool=True)
	RotatePolygon(M, P, Angle, Polygon.CenterX, Polygon.CenterY, TransformAfter)
	
	Return
End

Function RotatePolygonAroundCenter:Void(M:Matrix2D, P:Polygon, Angle:Float, ScaleX:Float, ScaleY:Float, TransformAfter:Bool=True)
	RotatePolygon(M, P, Angle, ScaleX, ScaleY, Polygon.CenterX, Polygon.CenterY, TransformAfter)
	
	Return
End

Function RotatePolygon:Void(M:Matrix2D, P:Polygon, Angle:Float, HandleX:Float=0.0, HandleY:Float=0.0, TransformAfter:Bool=True)
	HandleRotate(M, Angle, HandleX, HandleY)
	
	If (TransformAfter) Then
		TransformPoints(M, P)
	Endif
	
	Return
End

Function RotatePolygon:Void(M:Matrix2D, P:Polygon, Angle:Float, ScaleX:Float, ScaleY:Float, HandleX:Float, HandleY:Float, TransformAfter:Bool=True)
	HandleRotate(M, Angle, HandleX, HandleY)
	
	M.Scale(ScaleX, ScaleY)
	
	If (TransformAfter) Then
		TransformPoints(M, P)
	Endif
	
	Return
End

Function HandleRotate:Void(M:Matrix2D, Angle:Float, HandleX:Float, HandleY:Float)
	M.Translate(-HandleX, -HandleY)
	M.Rotate(Angle)
	
	Return
End

Function TransformPoints:Void(M:Matrix2D, P:Polygon)
	For Local I:= 0 Until P.Points.Length Step 2
		M.TransformPoint(P.Points, I)
	Next
	
	Return
End