import datetime

dates = {
    "02-22": "Eng",
    "02-27": "Chem",
    "03-04": "Phy",
    "03-06": "Farts",
    "03-09": "Meth",
    "04-02": "CS",
    "04-08": "JEE",
}

current_date = datetime.datetime.now()

for d in dates:
    exam_date = datetime.datetime.strptime(d + "-24", "%m-%d-%y")
    if exam_date > current_date:
        break

time_left = exam_date - current_date
days_left = time_left.days + time_left.seconds / (60 * 60 * 24) + 0.2
print("       <big><span color='#74c7ec'>", f"󰑴 {str(round(days_left, 1))} Days</span>","<span color='#fab387'>" + dates[d],"(" + d[-2:] + ")</span></big>        ")
