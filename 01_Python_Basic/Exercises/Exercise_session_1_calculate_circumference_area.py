''' Ex1
Calculate the circumference and area of a Square:

Input the side (canh) of the Square.
Calculate and store the results in variables circumference and area

Print out the result like this:
# Side of the Square: side
# Circumference: circumference
# Area:
'''
######################################################
#Tu's answer:

x = eval(input("Input value of the side: "))
cir = x*4
are = x**2

print("Side of the Square:",x, "\nCircumference:", cir , "\nArea:", are)


######################################################


''' Ex2
Calculate the circumference and area of a Triangle:

Input the 3 sides (canh) of the Triangle.
Calculate and store the results in variables circumference and area
(hint: use Heron formula to calculate the area of a triangle given 3 sides)

Print out the result like this:
# Side 1 of the Triangle: side_1
# Side 2 of the Triangle: side_2
# Side 3 of the Triangle: side_3
# Circumference: circumference
# Area: area
'''
######################################################
#Tu's answer:

x = eval(input("Input value of the first side: "))
y = eval(input("Input value of the second side: "))
z = eval(input("Input value of the third side: "))
cir = x+y+z

s = cir/2
are = (s*(s-x)*(s-y)*(s-z))**0.5

print("Side 1 of the Triangle:",x,
      "\nSide 2 of the Triangle:",y,
      "\nSide 3 of the Triangle:",z,
      "\nCircumference:", cir , 
      "\nArea:", are,)
