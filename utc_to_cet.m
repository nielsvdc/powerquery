/*
  Function created from the example at: https://community.powerbi.com/t5/Power-Query/Convert-Date-Time-in-UTC-to-Local-Time-with-Daylight-savings/m-p/790149#M26463

  Converts UTC datetime to CET datetime with summertime consideration.
*/
(DateTimeColumn as datetime) =>
let
    date = DateTime.Date(DateTimeColumn),
    time = DateTime.Time(DateTimeColumn),
    lastSundayOfOctober = Date.StartOfWeek(#date(Date.Year(date), 10, 31), Day.Sunday),
    lastSundayOfMarch = Date.StartOfWeek(#date(Date.Year(date), 3, 31), Day.Sunday),

    isSummerTime = (date = lastSundayOfMarch and time >= #time(2,0,0)) or
		(date > lastSundayOfMarch and date < lastSundayOfOctober) or 
		(date = lastSundayOfOctober and time <= #time(2,0,0)),

    timeZone = (1 + Number.From(isSummerTime)),

    CET = 
        DateTime.From(date) 
        + #duration(0,Time.Hour(time),Time.Minute(time),Time.Second(time))  
        + #duration(0, timeZone, 0, 0)
in
    CET
