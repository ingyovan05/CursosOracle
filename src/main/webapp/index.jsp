<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión Académica Oracle</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/unab-theme.css">
    <style>
        body { background: #f5f7fb; }
        .card-panel { border-radius: 16px; }
    </style>
</head>
<body>
<nav class="blue darken-3">
    <div class="nav-wrapper container">
        <a href="${pageContext.request.contextPath}/" class="brand-logo" aria-label="UNAB - Inicio">
            <img class="unab-logo" src="${pageContext.request.contextPath}/assets/img/logo-unab.png" alt="Universidad Autónoma de Bucaramanga">
        </a>
        <ul class="right hide-on-med-and-down">
            <li><a href="${pageContext.request.contextPath}/cursos">Cursos</a></li>
            <li><a href="${pageContext.request.contextPath}/estudiantes">Estudiantes</a></li>
            <li><a href="${pageContext.request.contextPath}/inscripciones">Inscripciones</a></li>
            <li><a href="${pageContext.request.contextPath}/periodos">Períodos</a></li>
            <li><a href="${pageContext.request.contextPath}/consultas">Consultas</a></li>
        </ul>
    </div>
</nav>
<div class="container section">
    <div class="row">
        <div class="col s12 m6">
            <div class="card-panel z-depth-2">
                <h4>CRUD con Oracle XE</h4>
                <p>Aplicación web en Java para administrar cursos, estudiantes, inscripciones y períodos desde Tomcat usando Maven y JDBC.</p>
                <a class="btn blue darken-2" href="${pageContext.request.contextPath}/cursos">Ir al CRUD</a>
                <a class="btn green darken-1" href="${pageContext.request.contextPath}/consultas">Ejecutar consultas</a>
            </div>
        </div>
        <div class="col s12 m6">
            <div class="card-panel z-depth-2">
                <h5>Conexión</h5>
                <p>Usuario: UDUARIO_YOVAN</p>
                <p>Base: XE</p>
                <p>Driver: ojdbc11</p>
            </div>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
