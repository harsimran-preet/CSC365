from numpy import *
from pandas import *

# Input formats

# S[tudent]: <lastname>
# S[tudent]: <lastname> [B[us]]
# T[eacher]: <lastname>
# B[us]: <number>
# G[rade]: <number> [H[igh]|L[ow]]
# A[verage]: <number>
# I[nfo]
# Q[uit]

def take_input(data):
    choice = str(input("\n"))
    choice = choice.split(" ")
    if ((choice[0] == "S:" or choice[0] == "Student:") and len(choice)==2):
        print(search_std_by_name(data, (choice[1]).upper()))
        take_input(data)
    elif ((choice[0] == "S:" or choice[0] == "Student:") and len(choice)==3 and (choice[2]=="B" or choice[2] =="Bus")):
        print(search_std_by_name_bus(data, (choice[1]).upper()))
        take_input(data)
    elif ((choice[0]=="T:" or choice[0]=="Teacher:") and len(choice) == 2):
        print(search_teacher_by_name(data, (choice[1]).upper()))
        take_input(data)
    elif ((choice[0]=="G:" or choice[0]=="Grade:") and len(choice) == 2):
        print(search_std_by_grade(data, choice[1]))
        take_input(data)
    elif ((choice[0]=="B:" or choice[0]=="Bus:") and len(choice) == 2):
        print(search_std_by_bus(data, int(choice[1])))
        take_input(data)
    elif ((choice[0] == "G:" or choice[0] == "Grade:") and len(choice) == 3 and (choice[2] == "H" or choice[2]=="High")):
        print(search_for_highest_GPA(data, int(choice[1])))
        take_input(data)
    elif ((choice[0] == "G:" or choice[0] == "Grade:") and len(choice) == 3 and (choice[2] == "L" or choice[2]=="Low")):
        print(search_for_lowest_GPA(data, int(choice[1])))
        take_input(data)
    elif ((choice[0] == "A:" or choice[0]=="Average:") and len(choice) == 2):
        print(search_avg_GPA(data, int(choice[1])))
        take_input(data)
    elif ((choice[0].upper()=="I" or choice[0].upper() == "INFO") and len(choice)==1):
        print(search_info(data))
        take_input(data)
    elif (choice[0].upper() == "Q" or choice[0].upper() == "QUIT"):
        print("\nThank you!")
        return 0
    else:
        print("\nInvalid input, try again\nSearch command examples:\n")
        print("S[tudent]: <lastname> [B[us]]\nT[eacher]: <lastname>\nB[us]: <number>\nG[rade]: <number> [H[igh]|L[ow]]\nA[verage]: <number>\nI[nfo]\nQ[uit]\n")
        take_input(data)
        
    


def main():
    try:
        data = read_csv('students.txt', sep=",", header=None)
        data.columns = ["StLastName", "StFirstName", "Grade", "Classroom", "Bus", "GPA", "TLastName", "TFirstName"]
    except:
        exit("File not found")
    #print(data[data['StLastName']=='HAVIR'])
    print("Welcome\n")

    print("S[tudent]: <lastname> [B[us]]\nT[eacher]: <lastname>\nB[us]: <number>\nG[rade]: <number> [H[igh]|L[ow]]\nA[verage]: <number>\nI[nfo]\nQ[uit]\n")
    take_input(data)

#R4
def search_std_by_name(data, name):
    if (data[data['StLastName']==name]).empty:
        return " "
    return(data[data['StLastName']==name])

#R5
def search_std_by_name_bus(data, name):
    student = data[data['StLastName']==name]
    if (student[['StLastName','StFirstName', "Bus"]]).empty:
        return " "
    return student[['StLastName','StFirstName', "Bus"]]

#R6
def search_teacher_by_name(data, name):
    teacher = data[data['TLastName']==name]
    if teacher[['StLastName','StFirstName']].empty:
        return " "
    return teacher[['StLastName','StFirstName']]

#R7
def search_std_by_grade(data, grade):
    student = data[data['Grade']==grade]
    if student[['StLastName','StFirstName']].empty:
        return " "
    return student[['StLastName','StFirstName']]

#R8
def search_std_by_bus(data, bus):
    student = data[data['Bus']==bus]
    if student[['StLastName','StFirstName', 'Grade', 'Classroom']].empty:
        return " "
    return student[['StLastName','StFirstName', 'Grade', 'Classroom']]

#R9a
def search_for_highest_GPA(data, num):
    student = data[data['Grade']==num]
    highestGPA = student.loc[student['GPA'].idxmax()]
    return highestGPA[["StLastName", "StFirstName", "GPA", "TLastName", "TFirstName", "Bus"]]

#R9b
def search_for_lowest_GPA(data, num):
    student = data[data['Grade']==num]
    lowestGPA = student.loc[student['GPA'].idxmin()]
    return lowestGPA[["StLastName", "StFirstName", "GPA", "TLastName", "TFirstName", "Bus"]]

#R10
def search_avg_GPA(data, num):
    student = data[data['Grade'] == num]
    avgGPA = student['GPA'].mean()
    return ("Grade Level: %s\nThe average GPA score computed: %.3f"%(num, avgGPA))

#R11
def search_info(data):
    grade0 = data[data['Grade'] == 0]
    grade1 = data[data['Grade'] == 1]
    grade2 = data[data['Grade'] == 2]
    grade3 = data[data['Grade'] == 3]
    grade4 = data[data['Grade'] == 4]
    grade5 = data[data['Grade'] == 5]
    grade6 = data[data['Grade'] == 6]
    #df = DataFrame(data= ["Grade 0: ": [grade0.shape[0]],"Grade 1: ": [grade1.shape[0]],"Grade 2: ": [grade2.shape[0]],"Grade 3: ": [grade3.shape[0]],"Grade 4: ": [grade4.shape[0]],"Grade 5: ": [grade5.shape[0]],"Grade 6: ": [grade6.shape[0]]])
    #return ("Grade 0: %d\nGrade 1: %d\nGrade 2: %d\nGrade 3: %d\nGrade 4: %d\nGrade 5: %d\nGrade 6: %d\n" %(grade0.shape[0],grade1.shape[0],grade2.shape[0],grade3.shape[0],grade4.shape[0],grade5.shape[0],grade6.shape[0]))
    df = DataFrame(data = [["Grade 0", grade0.shape[0]],["Grade 1", grade1.shape[0]],["Grade 2", grade2.shape[0]],["Grade 3", grade3.shape[0]],["Grade 4", grade4.shape[0]],["Grade 5", grade5.shape[0]],["Grade 6", grade6.shape[0]]])
    df.columns = ["Grade", "Number of Students"]
    df = df.set_index("Grade")
    return df
if __name__ == "__main__":
    main()


# data = read_csv('students.txt', sep=",", header=None)
# data.columns = ["StLastName", "StFirstName", "Grade", "Classroom", "Bus", "GPA", "TLastName", "TFirstName"]
# print(search_info(data))