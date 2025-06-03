'''
Ex1: datetime

Input your birthday as a string data

Q1: convert your birthday into datetime datatype
Q2: what is the weekday of your birthday?
Q3: what is the weekday of the last day of your birthmonth?
Q4: is your birth year a leap year? If not, what is the closest one to your birthyear?
Q5: what is the timedelta counted in days from your birthday to present?
'''
######################################################
#Tu's answer:

#Q1
from datetime import datetime
from datetime import date
import calendar

x = input("Type your birthday in DD-MM-YYYY:")

print(x)

b = datetime.strptime(x, "%d-%m-%Y")

print(b)

#Q2
print(b.strftime("%A"))

#Q3
c = date(b.year, b.month, calendar.monthrange(b.year, b.month)[1])

print(c.strftime("%A"))

#Q4
year = b.year

if calendar.isleap(year):
    print(f"The year {year} is a leap year")
else:
    print(f"The year {year} is not a leap year")

    for i in range(1, 100):
        if calendar.isleap(year - i):
            prev = year - i
            break
    for i in range(1, 100):
        if calendar.isleap(year + i):
            next = year + i
            break
    if (year - prev) <= (next - year):
        closest = prev
    else:
        closest = next

    print(f"The closest year to your birthyear: {closest}")


#Q5
today = datetime.today()
e = today - b
print(e.days)

##############################################

'''
Ex2: student classification

Input a student's score

Use conditions to classify that student:
    0  - 49: Weak
    50 - 59: Poor
    60 - 69: Satisfactory
    70 - 84: Good
    85 - 100: Excellent

Use try-except to ensure the right datatype of the input (float or integer)
Use try-assert to ensure the right range of the input (score >= 0, and score <= 100, not negative)
Use while loop to ask if the user wants to continue, set the break condition if the does not want to.
'''

######################################################
#Tu's answer:


try:
    score = float(input("Input your score:"))
    assert 0 <= score <= 100
except:
    print(">>> Error: Your input is not numeric and needs to be in range between 0 to 100")





while True:
    try:
        score = float(input("Input your score:"))
        assert 0 <= score <= 100
    except ValueError:
        print(">>> Error: Your input is not numeric!!!!")
        continue
    except AssertionError:
        print("Your score needs to be in range between 0 to 100")
        continue
    else:
        print("Your input is valid")
        break



if score < 50:
    r = "Weak"
elif score < 60:
    r = "Poor"
elif score < 70:
    r = "Satisfactory"
elif score < 85:
    r = "Good"
else:
    r = "Excellent"

print(f"Your score is: {score} -> {r}")




