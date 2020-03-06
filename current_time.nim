import times

func hourToSecond(hour: int): int = hour * 60 * 60

func tokyoTzInfo(time: Time): ZonedTime =
  ZonedTime(utcOffset: -9.hourToSecond, isDst: false, time: time)
proc nycTzInfo(time: Time): ZonedTime =
  ZonedTime(utcOffset: -5.hourToSecond, isDst: false, time: time)
proc sfTzInfo(time: Time): ZonedTime =
  ZonedTime(utcOffset: -7.hourToSecond, isDst: false, time: time)

let
  tzTokyo = newTimezone("Tokyo", tokyoTzInfo, tokyoTzInfo)
  tzNewYork = newTimezone("New York", nycTzInfo, nycTzInfo)
  tzSanFransisco = newTimezone("San Francisco", sfTzInfo, sfTzInfo)

echo "Tokyo: ", getTime().format("yyyy-MM-dd HH:mm", tzTokyo)
echo "New York: ", getTime().format("yyyy-MM-dd HH:mm", tzNewYork)
echo "San Fransisco: ", getTime().format("yyyy-MM-dd HH:mm", tzSanFransisco)
echo "UTC: ", getTime().format("yyyy-MM-dd HH:mm")
