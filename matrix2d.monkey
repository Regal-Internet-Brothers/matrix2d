Strict

Public

#Rem
	This module provides a refactored version of Simon "NoOdle" Ferguson's original implementation.
	
	His original implementation can be found here: http://www.monkey-x.com/Community/posts.php?topic=1992
#End

' Imports:
Import vector

' Classes:
Class Matrix2D
	' Constructor(s):
	Method New()
		LoadIdentity()
	End
	
	Method New(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
		Set(a, b, c, d, tx, ty)
	End
	
	' This will provide a new matrix with the same contents as this one.
	Method Clone:Matrix2D()
		Return New Matrix2D(Self.mA, Self.mB, Self.mC, Self.mD, Self.mTx, Self.mTy)
	End
	
	' Methods:
	Method Equals:Bool(M:Matrix2D)
		If (M = Self) Then
			Return True
		Endif
		
		Return ((M.mA = Self.mA) And (M.mB = Self.mB) And (M.mC = Self.mC) And (M.mD = Self.mD) And (M.mTx = Self.mTx) And (M.mTy = Self.mTy))
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
	
	' This concatenates this matrix with the input, combining the geometric effects of the two.
	Method Concatenate:Void(M:Matrix2D)
		Concatenate(M.mA, M.mB, M.mC, M.mD, M.mTx, M.mTy)
		
		Return
	End
	
	' This may be used to avoid creation of another 'Matrix2D' object.
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
		Local C:= Cos(Angle)
		Local S:= Sin(Angle)
		
		Concatenate(C, S, -S, C, 0.0, 0.0)
		
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
	
	' This performs the opposite transformation of the matrix.
	Method Invert:Void()
		Local det:= Self.Determinant
		
		Local a:Float = (Self.mD / det)
		Local b:Float = (-Self.mB / det)
		Local c:Float = (-Self.mC / det)
		Local d:Float = (Self.mA / det)
		
		Local tx:Float = (((Self.mC * Self.mTy) - (Self.mD * Self.mTx)) / det)
		Local ty:Float = (((Self.mB * Self.mTx) - (Self.mA * Self.mTy)) / det)
		
		Set(a, b, c, d, tx, ty)
		
		Return
	End

	' This applies the geometric transformation represented by the matrix to the specified point.
	' In other words, the real position of the point.
	Method TransformPoint:Void(Point:Vector2D<Float>)
		Point.X = TransformPointX(Point.X, Point.Y)
		Point.Y = TransformPointY(Point.X, Point.Y)
		
		Return
	End
	
	' This will generate a new 2D vector using the input.
	Method TransformPoint:Vector2D<Float>(X:Float, Y:Float)
		Local V:= New Vector2D<Float>(X, Y)
		
		TransformPoint(V)
		
		Return V
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
		Return "[a: " + Self.mA + ", " + "b: " + Self.mB + ", " + "c: " + Self.mC + ", " + "d: " + Self.mD + ", " + "tx: " + Self.mTx + ", " + "ty: " + Self.mTy + "]"
	End
	
	' This calculates the determinate of the matrix.
	Method Determinant:Float() Property
    	Return ((Self.mA * Self.mD) - (Self.mC * Self.mB))
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