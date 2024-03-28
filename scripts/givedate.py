import datetime

dates = {
    "02-22": "Eng",
    "02-27": "Chem",
    "03-04": "Phy",
    "03-06": "Farts",  # Fine Arts
    "03-09": "Meth",
    # "03-18": "Mock 1",
    # "03-21": "Mock 2",
    # "03-24": "Mock 3",
    # "03-27": "Mock 4",
    # "03-30": "Mock 5",
    "04-02": "CS",
    "04-08": "CS",
}

current_date = datetime.datetime.now()

for d in dates:
    exam_date = datetime.datetime.strptime(d + "-24", "%m-%d-%y")
    if exam_date > current_date:
        break

time_left = exam_date - current_date
days_left = time_left.days + time_left.seconds / (60 * 60 * 24) + 0.1
print("       <big><span color='#74c7ec'>", f"󰑴 {str(round(days_left, 1))} Days</span>","<span color='#fab387'>" + dates[d],"(" + d[-2:] + ")</span></big>        ")
