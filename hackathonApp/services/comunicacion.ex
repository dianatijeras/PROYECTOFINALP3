defmodule Comunicacion do
  @moduledoc """
  Servicio encargado de manejar la comunicación dentro de la hackathon.
  """

  @doc """
  Envía un mensaje desde un participante a otro.
  Retorna una tupla indicando el resultado.
  """
  @spec enviar_mensaje(String.t(), String.t(), String.t()) :: {:ok, String.t()}
  def enviar_mensaje(remitente, destinatario, mensaje) do
    {:ok, "Mensaje enviado de #{remitente} a #{destinatario}: #{mensaje}"}
  end

  @doc """
  Registra una retroalimentación en el historial de un proyecto.

  Si el proyecto existe, agrega el comentario y devuelve el proyecto actualizado.
  """
  @spec agregar_retroalimentacion(Proyecto.t(), String.t()) :: Proyecto.t()
  def agregar_retroalimentacion(%Proyecto{} = proyecto, comentario) do
    historial = proyecto.historial_retroalimentacion ++ [comentario]
    %{proyecto | historial_retroalimentacion: historial}
  end
end
