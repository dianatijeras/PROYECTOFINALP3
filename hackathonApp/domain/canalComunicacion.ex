defmodule CanalComunicacion do

  @moduledoc """
  modulo que representa un canal de comunicacion
  """

  defstruct id: " ", tipo: " ", nombre: " ", participantes: " "

  def crear_canal_comunciacion(id, tipo, nombre, participantes) do
    %__MODULE__{id: id, tipo: tipo, nombre: nombre, participantes: participantes}
  end

end
