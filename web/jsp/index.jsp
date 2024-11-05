<%-- 
    Document   : index
    Created on : 4 nov 2024, 19:56:18
    Author     : fgmrr
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    List<String> asientosTotales = new ArrayList<>();
    for (int i = 1; i <= 18; i++) {
        asientosTotales.add("A" + i);
    }
    session.setAttribute("asientosTotales", asientosTotales);

    List<String> asientosDisponibles = (List<String>) session.getAttribute("asientosDisponibles");
    if (asientosDisponibles == null) {
        asientosDisponibles = new ArrayList<>(asientosTotales);
        session.setAttribute("asientosDisponibles", asientosDisponibles);
    }

    String nombre = request.getParameter("nombre");
    String asientoSeleccionado = request.getParameter("asiento");

    if (nombre != null && !nombre.isEmpty() && asientoSeleccionado != null && asientosDisponibles.contains(asientoSeleccionado)) {
        asientosDisponibles.remove(asientoSeleccionado); 
        session.setAttribute("asientosDisponibles", asientosDisponibles);
        request.setAttribute("mensaje", "Reserva confirmada para " + nombre + " en el asiento " + asientoSeleccionado);
    } else if (asientoSeleccionado != null) {
        request.setAttribute("mensaje", "El asiento seleccionado no está disponible.");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserva de Asientos en Autobús</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0;
            padding: 20px;
        }
        .bus {
            display: grid;
            grid-template-columns: repeat(2, 60px);
            gap: 10px;
            padding: 20px;
            border: 2px solid #333;
            background-color: #f0f0f0;
            border-radius: 10px;
            width: max-content;
        }
        .asiento {
            width: 50px;
            height: 50px;
            background-color: #4CAF50;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
        }
        .asiento.reservado {
            background-color: #cccccc; 
            color: #666666;
            cursor: not-allowed;
        }
        .form-section, .message {
            margin: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>Reserva de Asientos en Autobús</h2>

    <div class="form-section">
        <form method="POST">
            <label for="nombre">Ingrese su nombre:</label>
            <input type="text" id="nombre" name="nombre" required>

            <label for="asiento">Seleccione su asiento:</label>
            <select id="asiento" name="asiento" required>
                <c:forEach var="asiento" items="${sessionScope.asientosDisponibles}">
                    <option value="${asiento}">${asiento}</option>
                </c:forEach>
            </select>

            <input type="submit" value="Reservar Asiento">
        </form>
    </div>

    <c:if test="${not empty mensaje}">
        <div class="message"><strong>${mensaje}</strong></div>
    </c:if>

    <div class="bus">
        <c:forEach var="asiento" items="${sessionScope.asientosTotales}">
            <div class="asiento ${sessionScope.asientosDisponibles.contains(asiento) ? '' : 'reservado'}">
                ${asiento}
            </div>
        </c:forEach>
    </div>
</body>
</html>