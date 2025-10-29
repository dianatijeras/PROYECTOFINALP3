defmodule Equipo do

  @moduledoc """
  modulo que representa un equipo
  """

  defstruct id: " ", nombre: " ", categoria: " ", lista_participantes: [], id_proyecto: " "

  def crear_equipo(id, nombre, categoria, lista_participantes, id_proyecto) do
    %__MODULE__{id: id, nombre: nombre, categoria: categoria, lista_participantes: lista_participantes, id_proyecto: id_proyecto}
  end

  def agregar_participante(equipo, participante) do
    %{equipo | lista_participantes: [participante | equipo.lista_participantes]}
  end

end
