<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Consultas Oracle</title>
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
    <h4>Consultas dinámicas sobre Oracle</h4>
    <form method="post" action="${pageContext.request.contextPath}/consultas" class="card-panel">
        <div class="input-field">
            <textarea id="sql" name="sql" class="materialize-textarea">${sql}</textarea>
            <label for="sql" class="${not empty sql ? 'active' : ''}">SQL</label>
        </div>
        <button class="btn green" type="submit">Ejecutar</button>
    </form>

    <c:if test="${not empty error}">
        <div class="card red lighten-4 black-text" style="padding: 12px;">
            <strong>Error:</strong> ${error}
        </div>
    </c:if>

    <c:if test="${not empty columns}">
        <table class="striped highlight responsive-table">
            <thead>
            <tr>
                <c:forEach var="column" items="${columns}">
                    <th>${displayColumns[column]}</th>
                </c:forEach>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${rows}">
                <tr>
                    <c:forEach var="column" items="${columns}">
                        <td>${row[column]}</td>
                    </c:forEach>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        M.updateTextFields();
        M.textareaAutoResize(document.getElementById('sql'));
    });
</script>
</body>
</html>
