defmodule Benchee.Formatters.D3Test do
  use ExUnit.Case
  alias Benchee.Formatters.D3

  @filename "my.html"
  @sample_suite %{
                  config: %{d3: %{file: @filename}},
                  statistics: %{
                    "My Job" => %{
                      average: 200.0,
                      ips: 5000.0,
                      std_dev: 20,
                      std_dev_ratio: 0.1,
                      std_dev_ips: 500,
                      median: 190.0
                    }
                  },
                  run_times: %{"My Job" => [190, 200, 210]}
                }
  test ".format returns an HTML-ish string" do
    html = D3.format @sample_suite
    assert html =~ ~r/<html>.+<script>.+<\/html>/si
  end

  test ".format has the important suite data in the html result" do
    html = D3.format @sample_suite

    assert_includes html, ["[190,200,210]", "5.0e3",
                           "200.0", "190.0", "My Job"]

  end

  defp assert_includes(html, expected_contents) do
    Enum.each expected_contents, fn(expected_content) ->
      assert html =~ expected_content
    end
  end

  test ".output returns the suite again unchanged" do
    try do
      return = Benchee.Formatters.D3.output(@sample_suite)
      assert return == @sample_suite
      assert File.exists? @filename
    after
      File.rm! @filename
    end
  end
end
