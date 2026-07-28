<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administrar estudiantes</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/unab-theme.css">
</head>
<body>
<nav class="blue darken-3">
    <div class="nav-wrapper container">
        <a href="${pageContext.request.contextPath}/" class="brand-logo" aria-label="UNAB - Inicio">
            <img class="unab-logo" src="${pageContext.request.contextPath}/assets/img/logo-unab.png" alt="Universidad Autónoma de Bucaramanga">
        </a>
        <ul class="right">
            <li><a href="${pageContext.request.contextPath}/cursos">Cursos</a></li>
            <li><a href="${pageContext.request.contextPath}/estudiantes">Estudiantes</a></li>
            <li><a href="${pageContext.request.contextPath}/inscripciones">Inscripciones</a></li>
            <li><a href="${pageContext.request.contextPath}/periodos">Períodos</a></li>
            <li><a href="${pageContext.request.contextPath}/consultas">Consultas</a></li>
        </ul>
    </div>
</nav>
<div class="container section">
    <h4>Estudiantes</h4>
    <div class="row">
        <div class="col s12 m5">
            <form method="post" action="${pageContext.request.contextPath}/estudiantes" class="card-panel z-depth-2">
                <h5 style="margin-top: 0;">Formulario</h5>
                <input type="hidden" name="action" value="guardar" />
                <c:forEach var="column" items="${columns}">
                    <div class="input-field">
                        <input id="${column.columnName}" name="${column.columnName}" type="text" value="${selectedRow[column.columnName] != null ? selectedRow[column.columnName] : ''}" class="${selectedRow[column.columnName] != null ? 'validate' : ''}" />
                        <label for="${column.columnName}" class="${selectedRow[column.columnName] != null ? 'active' : ''}">${column.displayName}</label>
                    </div>
                </c:forEach>
                <button class="btn blue" type="submit">Guardar</button>
            </form>
        </div>
        <div class="col s12 m7">
            <h5>Registros</h5>
            <div class="crud-filter" data-crud-filter="tabla-estudiantes">
                <div class="input-field">
                    <i class="material-icons prefix">search</i>
                    <input id="buscar-estudiantes" type="search" class="crud-filter-input" autocomplete="off" placeholder="Buscar por estudiante, documento, nombre o estado">
                </div>
                <button type="button" class="btn-flat crud-filter-clear" title="Limpiar búsqueda"><i class="material-icons">close</i></button>
                <span class="crud-filter-count" aria-live="polite"></span>
            </div>
            <table id="tabla-estudiantes" class="striped highlight responsive-table">
        <thead>
        <tr>
            <c:forEach var="column" items="${columns}">
                <th>${column.displayName}</th>
            </c:forEach>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${rows}">
            <tr data-record-row>
                <c:forEach var="column" items="${columns}">
                    <td>${row[column.columnName]}</td>
                </c:forEach>
                <td>
                    <a class="btn-small orange" href="${pageContext.request.contextPath}/estudiantes?action=editar&id=${row[pkColumnName]}">Editar</a>
                    <form method="post" style="display:inline" action="${pageContext.request.contextPath}/estudiantes">
                        <input type="hidden" name="action" value="eliminar" />
                        <input type="hidden" name="id" value="${row[pkColumnName]}" />
                        <button class="btn-small red" type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
        <tfoot><tr><td class="crud-no-results" colspan="${columns.size() + 1}">No se encontraron estudiantes.</td></tr></tfoot>
    </table>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/crud-filter.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        M.updateTextFields();
    });
</script>
