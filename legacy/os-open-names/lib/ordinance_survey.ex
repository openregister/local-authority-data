defmodule OrdinanceSurvey do

  @headers ~W[ID
NAMES_URI
NAME1
NAME1_LANG
NAME2
NAME2_LANG
TYPE
LOCAL_TYPE
GEOMETRY_X
GEOMETRY_Y
MOST_DETAIL_VIEW_RES
LEAST_DETAIL_VIEW_RES
MBR_XMIN
MBR_YMIN
MBR_XMAX
MBR_YMAX
POSTCODE_DISTRICT
POSTCODE_DISTRICT_URI
POPULATED_PLACE
POPULATED_PLACE_URI
POPULATED_PLACE_TYPE
DISTRICT_BOROUGH
DISTRICT_BOROUGH_URI
DISTRICT_BOROUGH_TYPE
COUNTY_UNITARY
COUNTY_UNITARY_URI
COUNTY_UNITARY_TYPE
REGION
REGION_URI
COUNTRY
COUNTRY_URI
RELATED_SPATIAL_OBJECT
SAME_AS_DBPEDIA
SAME_AS_GEONAMES]
  |> Enum.join(",")

  def stream(input \\ "TL00", filter \\ nil) do
    stream = File.stream!("cache/DATA/#{input}.csv")
    if filter do
      stream = ParallelStream.filter(stream, &(String.contains?(&1, filter)))
    end
    if Enum.at(stream, 0) do
      Stream.concat([@headers], stream)
      |> DataMorph.structs_from_csv(OS, OpenName)
    else
      []
    end
  end

  def uri_end uri do
    uri |> String.split("/") |> List.last
  end

  def write_all do
    {:ok, file} = File.open("os.tsv", [:write])
    IO.write(file, "os\tname\ttype\tparent-os\n")
    File.close file
    {:ok, files} = File.ls("cache/DATA")
    files
    |> Enum.reverse
    |> Stream.map(&(&1 |> String.split("/") |> List.last |> String.replace(".csv","") ))
    |> Stream.each(&IO.puts/1)
    |> Stream.flat_map(&get_data/1)
    |> Stream.uniq(&(&1))
    |> Stream.each(&write_data/1)
    |> Enum.count
  end

  def get_data input do
    counties = counties(input) |> Enum.map(&(&1 |> Enum.join("\t") ))
    districts = districts(input) |> Enum.map(&(&1 |> Enum.join("\t") ))
    counties ++ districts
  end

  def write_data row do
    {:ok, file} = File.open("os.tsv", [:append])
    IO.write(file, row)
    IO.write(file, "\n")
    File.close(file)
  end

  def unique(stream, field) do
    stream
    |> Stream.filter(&( Map.get(&1, field) != ""))
    |> Stream.uniq(&( Map.get(&1, field) ))
  end

  def counties(input \\ "TL00") do
    stream(input)
    |> unique(:county_unitary)
    |> Stream.map(&(
      [
        &1.county_unitary_uri |> uri_end,
        &1.county_unitary,
        &1.county_unitary_type |> uri_end,
        nil
      ] ))
  end

  def districts(input \\ "TL00") do
    stream(input)
    |> unique(:district_borough)
    |> Stream.map(&(
      [
        &1.district_borough_uri |> uri_end,
        &1.district_borough,
        &1.district_borough_type |> uri_end,
        &1.county_unitary_uri |> uri_end
      ]
    ))
  end

end
