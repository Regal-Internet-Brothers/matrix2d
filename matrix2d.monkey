Strict

Public

#Rem
	This module provides a refactored version of Simon "NoOdle" Ferguson's original implementation.
	
	His original implementation can be found here: http://www.monkey-x.com/Community/posts.php?topic=1992
#End

' Imports:
Import regal.vector

' Classes:
Class Matrix2D
	' Constructor(s):
	Method New()
		LoadIdentity()
	End
	
	Method New(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
		Set(a, b, c, d, tx, ty)
	End
	
	Method New(Data:Float[], Offset:Int=0)
		Set(Data, Offset)
	End
	
	Method New(M:Matrix2D)
		Set(M)
	End
	
	' This will provide a new matrix with the same contents as this one.
	Method Clone:Matrix2D()
		Return New Matrix2D(Self)
	End
	
	' Methods:
	Method ToArray:Float[]()
		Return [mA, mB, mC, mD, mTx, mTy]
	End
	
	Method Equals:Bool(M:Matrix2D)
		If (M = Self) Then
			Return True
		Endif
		
		Return Equals(M.mA, M.mB, M.mC, M.mD, M.mTx, M.mTy)
	End
	
	Method Equals:Bool(Data:Float[], Offset:Int=0)
		Return Equals(Data[Offset], Data[Offset+1], Data[Offset+2], Data[Offset+3], Data[Offset+4], Data[Offset+5])
	End
	
	Method Equals:Bool(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
		Return ((a = Self.mA) And (b = Self.mB) And (c = Self.mC) And (d = Self.mD) And (tx = Self.mTx) And (ty = Self.mTy))
	End
	
	' This allows you to manually set each value of this matrix.
	Method Set:Void(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
		Self.mA = a
		Self.mB = b
		Self.mC = c
		Self.mD = d
		Self.mTx = tx
		Self.mTy = ty
		
		Return
	End
	
	Method Set:Void(M:Matrix2D)
		Set(M.mA, M.mB, M.mC, M.mD, M.mTx, M.mTy)
		
		Return
	End
	
	Method Set:Void(Data:Float[], Offset:Int=0)
		Set(Data[Offset], Data[Offset+1], Data[Offset+2], Data[Offset+3], Data[Offset+4], Data[Offset+5])
		
		Return
	End
	
	Method Get:Float(Index:Int)
		' Array behavior:
		Select Index
			Case 0
				Return mA
			Case 1
				Return mB
			Case 2
				Return mC
			Case 3
				Return mD
			Case 4
				Return mTx
			Case 5
				Return mTy
		End Select
		
		Return 0.0
	End
	
	' This concatenates this matrix with the input,
	' combining the geometric effects of the two;
	' this command DOES NOT create a new 'Matrix2D' object.
	Method Concatenate:Void(M:Matrix2D)
		Concatenate(M.mA, M.mB, M.mC, M.mD, M.mTx, M.mTy)
		
		Return
	End
	
	' This may be used to avoid creation of another 'Matrix2D' object.
	' This overload obviously follows the same rules as the container-based one.
	Method Concatenate:Void(mA:Float, mB:Float, mC:Float, mD:Float, mTx:Float, mTy:Float)
		Local a:Float = (mA * Self.mA  + mC * Self.mB)
		Local b:Float = (mB * Self.mA  + mD * Self.mB)
		Local c:Float = (mA * Self.mC  + mC * Self.mD)
		Local d:Float = (mB * Self.mC  + mD * Self.mD)
		Local tx:Float = (mA * Self.mTx + mC * Self.mTy + mTx)
		Local ty:Float = (mB * Self.mTx + mD * Self.mTy + mTy)
		
		Set(a, b, c, d, tx, ty)
		
		Return
	End
	
	Method Concatenate:Void(Data:Float[], Offset:Int=0)
		Concatenate(Data[Offset], Data[Offset+1], Data[Offset+2], Data[Offset+3], Data[Offset+4], Data[Offset+5])
		
		Return
	End
	
	' This translates a matrix along the X and Y axes.
	Method Translate:Void(X:Float, Y:Float)
		Self.mTx += X
		Self.mTy += Y
		
		Return
	End
	
	'/ Applies a scaling transformation To the matrix.
	Method Scale:Void(SX:Float, SY:Float)
		mA *= SX
		mB *= SY
		mC *= SX
		mD *= SY
		mTx *= SX
		mTy *= SY
		
		Return
	End
	
	' This applies a uniform scaling transformation to the matrix.
	Method Scale:Void(Scalar:Float)
		Scale(Scalar, Scalar)
		
		Return
	End
	
	' This applies a rotation on the matrix.
	Method Rotate:Void(Angle:Float)
		Rotate(Sin(Angle), Cos(Angle))
		
		Return
	End
	
	Method Rotate:Void(RSin:Float, RCos:Float)
		Rotate(RSin, RCos, -RSin)
		
		Return
	End
	
	Method Rotate:Void(RSin:Float, RCos:Float, NRSin:Float)
		Concatenate(RCos, RSin, NRSin, RCos, 0.0, 0.0)
		
		Return
	End
	
	' This applies a shearing transformation to the matrix.
	Method Shear:Void(SX:Float, SY:Float)	
		Self.mC += SX
		Self.mB += SY
		
		Return
	End
	
	' This applies a uniform shearing transformation to the matrix.
	Method Shear:Void(Scalar:Float)	
		Self.mC *= Scalar
		Self.mB *= Scalar
		
		Return
	End
	
	' This sets each matrix property to a value that causes a "Null transformation".
	Method LoadIdentity:Void()
		Self.Set(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)
		
		Return
	End
	
	' Currently a macro for 'LoadIdentity'.
	Method Reset:Void()
		LoadIdentity()
		
		Return
	End
	
	' This performs an inversion transformation on this matrix:
	Method Invert:Void()
		Invert(Determinant)
		
		Return
	End
	
	Method Invert:Void(Determinant:Float)
		Local a:Float = (Self.mD / Determinant)
		Local b:Float = (-Self.mB / Determinant)
		Local c:Float = (-Self.mC / Determinant)
		Local d:Float = (Self.mA / Determinant)
		
		Local tx:Float = (((Self.mC * Self.mTy) - (Self.mD * Self.mTx)) / Determinant)
		Local ty:Float = (((Self.mB * Self.mTx) - (Self.mA * Self.mTy)) / Determinant)
		
		Set(a, b, c, d, tx, ty)
		
		Return
	End

	' This applies the geometric transformation represented by the matrix to the specified point.
	' In other words, the real position of the point.
	Method TransformPoint:Void(Point:Vector2D<Float>)
		' Local variable(s):
		
		' Keep track of the initial X and Y values:
		Local PX:= Point.X
		Local PY:= Point.Y
		
		Point.X = TransformPointX(PX, PY)
		Point.Y = TransformPointY(PX, PY)
		
		Return
	End
	
	' This will generate a new 2D vector using the input.
	Method TransformPoint:Vector2D<Float>(X:Float, Y:Float)
		Local V:= New Vector2D<Float>(X, Y)
		
		TransformPoint(V)
		
		Return V
	End
	
	Method TransformPoint:Void(Output:Float[], X:Float, Y:Float, Offset:Int=0)
		Output[Offset] = TransformPointX(X, Y)
		Output[Offset+1] = TransformPointY(X, Y)
		
		Return
	End
	
	Method TransformPoint_ToArray:Float[](X:Float, Y:Float)
		Local Output:Float[2]
		
		TransformPoint(Output, X, Y)
		
		Return Output
	End
	
	' This will modify the 'XY' array by transforming its contents.
	Method TransformPoint:Void(XY:Float[], Offset:Int=0)
		' Local variable(s):
		
		' Keep track of the initial X and Y values:
		Local X:= XY[Offset]
		Local Y:= XY[Offset+1]
		
		XY[Offset] = TransformPointX(X, Y)
		XY[Offset+1] = TransformPointY(X, Y)
		
		Return
	End
	
	' Both X and Y positions are required to use these commands:
	Method TransformPointX:Float(X:Float, Y:Float)
		Return ((Self.mA * X) + (Self.mC * Y) + Self.mTx)
	End
	
	Method TransformPointY:Float(X:Float, Y:Float)
		Return ((Self.mB * X) + (Self.mD * Y) + Self.mTy)
	End
	
	' Properties:
	Method ToString:String() Property
		Return "[A: " + Self.mA + ", " + "B: " + Self.mB + ", " + "C: " + Self.mC + ", " + "D: " + Self.mD + ", " + "TX: " + Self.mTx + ", " + "TY: " + Self.mTy + "]"
	End
	
	' This calculates the determinate of the matrix.
	Method Determinant:Float() Property
		Return ((Self.mA * Self.mD) - (Self.mC * Self.mB))
	End
	
	Method A:Float() Property
		Return mA
	End
	
	Method B:Float() Property
		Return mB
	End
	
	Method C:Float() Property
		Return mC
	End
	
	Method D:Float() Property
		Return mD
	End
	
	Method TX:Float() Property
		Return mTx
	End
	
	Method TY:Float() Property
		Return mTy
	End
	
	' Fields (Public):
	' Nothing so far.
	
	' Fields (Protected):
	Protected
	
	Field mA:Float
	Field mB:Float
	Field mC:Float
	Field mD:Float
	Field mTx:Float
	Field mTy:Float
	
	Public
End