# Credit to https://gist.github.com/LostKobrakai/7137eb20ed59fc8c6af0e94331cf470c
defmodule DateTimeGenerators do
  use ExUnitProperties

  @time_zones ["Etc/UTC"]

  def date do
    gen all(
          year <- integer(1970..2050),
          month <- integer(1..12),
          day <- integer(1..31),
          match?({:ok, _}, Date.from_erl({year, month, day}))
        ) do
      Date.from_erl!({year, month, day})
    end
  end

  def time do
    gen all(
          hour <- integer(0..23),
          minute <- integer(0..59),
          second <- integer(0..59)
        ) do
      Time.from_erl!({hour, minute, second})
    end
  end

  def naive_datetime do
    gen all(
          date <- date(),
          time <- time()
        ) do
      {:ok, naive_datetime} = NaiveDateTime.new(date, time)
      naive_datetime
    end
  end

  def datetime do
    gen all(
          naive_datetime <- naive_datetime(),
          time_zone <- member_of(@time_zones)
        ) do
      DateTime.from_naive!(naive_datetime, time_zone)
    end
  end
end
