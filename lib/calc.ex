defmodule Calc do
  def main do
    spawn(fn -> loop(0) end) # repl also acts as a process too, so we can send and receive messages back and forth
  end

  # private
  # val init will be zero
  defp loop(val) do
    new_val = receive do
      {:value, client_id} -> send(client_id, {:response, val})

      val

      {:add, value} -> val + value
      {:subtract, value} -> val - value
      {:multiply, value} -> val * value
      {:divide, value} -> div(val, value)

      invalid_request -> IO.inspect invalid_request

      val
    end
    loop(new_val)
  end

  def get_value(server_id) do
    send(server_id, {:value, self()}) # self => Returns the current state of the function (add, sub, funcs...), back to the client
    receive do
      {:response, value} -> value
    end

  end

  def add(server_id, val) do
    send(server_id, {:add, val})
    get_value(server_id)
  end

  def subtract(server_id, val) do
    send(server_id, {:subtract, val})
    get_value(server_id)
  end

  def multiply(server_id, val) do
    send(server_id, {:multiply, val})
    get_value(server_id)
  end

  def divide(server_id, val) do
    send(server_id, {:divide, val})
    get_value(server_id)
  end

end
