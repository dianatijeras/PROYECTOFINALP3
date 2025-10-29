defmodule Mentor do

  @moduledoc """
  modulo que representa un mentor
  """

  defstruct nombre: " ", especialidad: " ", equipos_asignados: " "

  def crear_mentor(nombre, especialidad, equipos_asignados) do
    %__MODULE__{nombre: nombre, especialidad: especialidad, equipos_asignados: equipos_asignados}
  end
end
