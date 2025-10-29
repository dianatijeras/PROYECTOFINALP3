defmodule Mensaje do

  @moduledoc """
  modulo que representa un mensaje
  """

  defstruct remitente: " ", contenido: " ", timestamp: " ", canal: " "

  def crear_mensaje(remitente, contenido, timestamp, canal) do
    %__MODULE__{remitente: remitente, contenido: contenido, timestamp: timestamp, canal: canal}
  end

end
