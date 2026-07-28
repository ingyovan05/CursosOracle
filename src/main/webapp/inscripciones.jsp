<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrar inscripciones</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/unab-theme.css">
    <style>
        body { background: #f5f7fb; }
        .card-panel { border-radius: 14px; }
        .lookup-field { display: flex; align-items: center; gap: 10px; margin: 12px 0 24px; }
        .lookup-field .select-wrapper { flex: 1; }
        .lookup-field .btn { flex: 0 0 auto; padding: 0 14px; }
        .modal { width: 75%; max-height: 85%; }
        .select-row { cursor: pointer; }
        .select-row:hover { background: #e3f2fd !important; }
        .modal-search { margin-bottom: 8px; }
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
    <h4>Inscripciones</h4>
    <div class="row">
        <div class="col s12 l5">
            <form method="post" action="${pageContext.request.contextPath}/inscripciones" class="card-panel z-depth-2">
                <h5 style="margin-top:0">${selectedRow != null ? 'Editar inscripción' : 'Nueva inscripción'}</h5>
                <input type="hidden" name="action" value="guardar">

                <div class="input-field">
                    <input id="ID_INSCRIPCION" name="ID_INSCRIPCION" type="text"
                           value="${selectedRow['ID_INSCRIPCION'] != null ? selectedRow['ID_INSCRIPCION'] : ''}"
                           class="validate" ${selectedRow != null ? 'readonly' : ''}>
                    <label for="ID_INSCRIPCION" class="${selectedRow['ID_INSCRIPCION'] != null ? 'active' : ''}">Inscripción</label>
                </div>

                <label>Estudiante</label>
                <div class="lookup-field">
                    <select id="ID_ESTUDIANTE" name="ID_ESTUDIANTE" required>
                        <option value="" disabled ${selectedRow['ID_ESTUDIANTE'] == null ? 'selected' : ''}>Seleccione un estudiante</option>
                        <c:forEach var="item" items="${estudiantes}">
                            <option value="${item['ID_ESTUDIANTE']}" ${selectedRow['ID_ESTUDIANTE'] == item['ID_ESTUDIANTE'] ? 'selected' : ''}>
                                ${item['DOCUMENTO']} - ${item['NOMBRE']}
                            </option>
                        </c:forEach>
                    </select>
                    <button class="btn blue waves-effect modal-trigger" type="button" data-target="modal-estudiantes" title="Buscar estudiante">
                        <i class="material-icons">search</i>
                    </button>
                </div>

                <label>Curso</label>
                <div class="lookup-field">
                    <select id="ID_CURSO" name="ID_CURSO" required>
                        <option value="" disabled ${selectedRow['ID_CURSO'] == null ? 'selected' : ''}>Seleccione un curso</option>
                        <c:forEach var="item" items="${cursos}">
                            <option value="${item['ID_CURSO']}" ${selectedRow['ID_CURSO'] == item['ID_CURSO'] ? 'selected' : ''}>
                                ${item['CODIGO']} - ${item['NOMBRE']}
                            </option>
                        </c:forEach>
                    </select>
                    <button class="btn blue waves-effect modal-trigger" type="button" data-target="modal-cursos" title="Buscar curso">
                        <i class="material-icons">search</i>
                    </button>
                </div>

                <label>Período</label>
                <div class="lookup-field">
                    <select id="ID_PERIODO" name="ID_PERIODO" required>
                        <option value="" disabled ${selectedRow['ID_PERIODO'] == null ? 'selected' : ''}>Seleccione un periodo</option>
                        <c:forEach var="item" items="${periodos}">
                            <option value="${item['ID_PERIODO']}" ${selectedRow['ID_PERIODO'] == item['ID_PERIODO'] ? 'selected' : ''}>
                                ${item['CODIGO']} - ${item['NOMBRE']}
                            </option>
                        </c:forEach>
                    </select>
                    <button class="btn blue waves-effect modal-trigger" type="button" data-target="modal-periodos" title="Buscar periodo">
                        <i class="material-icons">search</i>
                    </button>
                </div>

                <div class="input-field">
                    <input id="NOTA" name="NOTA" type="number" step="0.01" min="0" max="5"
                           value="${selectedRow['NOTA'] != null ? selectedRow['NOTA'] : ''}">
                    <label for="NOTA" class="${selectedRow['NOTA'] != null ? 'active' : ''}">Nota</label>
                </div>

                <div class="input-field">
                    <select id="ESTADO" name="ESTADO" required>
                        <option value="" disabled ${selectedRow['ESTADO'] == null ? 'selected' : ''}>Seleccione un estado</option>
                        <option value="ACTIVO" ${selectedRow['ESTADO'] == 'ACTIVO' ? 'selected' : ''}>Activo</option>
                        <option value="INACTIVO" ${selectedRow['ESTADO'] == 'INACTIVO' ? 'selected' : ''}>Inactivo</option>
                    </select>
                    <label for="ESTADO">Estado</label>
                </div>

                <button class="btn blue" type="submit"><i class="material-icons left">save</i>Guardar</button>
                <c:if test="${selectedRow != null}">
                    <a class="btn-flat" href="${pageContext.request.contextPath}/inscripciones">Cancelar</a>
                </c:if>
            </form>
        </div>

        <div class="col s12 l7">
            <h5>Registros</h5>
            <div class="crud-filter" data-crud-filter="tabla-inscripciones">
                <div class="input-field">
                    <i class="material-icons prefix">search</i>
                    <input id="buscar-inscripciones" type="search" class="crud-filter-input" autocomplete="off" placeholder="Buscar en las inscripciones">
                </div>
                <button type="button" class="btn-flat crud-filter-clear" title="Limpiar búsqueda"><i class="material-icons">close</i></button>
                <span class="crud-filter-count" aria-live="polite"></span>
            </div>
            <table id="tabla-inscripciones" class="striped highlight responsive-table">
                <thead><tr>
                    <c:forEach var="column" items="${columns}"><th>${column.displayName}</th></c:forEach>
                    <th>Acciones</th>
                </tr></thead>
                <tbody>
                <c:forEach var="row" items="${rows}">
                    <tr data-record-row>
                        <c:forEach var="column" items="${columns}"><td>${row[column.columnName]}</td></c:forEach>
                        <td>
                            <a class="btn-small orange" href="${pageContext.request.contextPath}/inscripciones?action=editar&id=${row[pkColumnName]}">Editar</a>
                            <form method="post" style="display:inline" action="${pageContext.request.contextPath}/inscripciones">
                                <input type="hidden" name="action" value="eliminar">
                                <input type="hidden" name="id" value="${row[pkColumnName]}">
                                <button class="btn-small red" type="submit">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot><tr><td class="crud-no-results" colspan="${columns.size() + 1}">No se encontraron inscripciones.</td></tr></tfoot>
            </table>
        </div>
    </div>
</div>

<div id="modal-estudiantes" class="modal">
    <div class="modal-content">
        <h5>Seleccionar estudiante</h5>
        <div class="input-field modal-search">
            <i class="material-icons prefix">search</i>
            <input type="text" class="lookup-search" data-table="table-estudiantes" placeholder="Buscar por documento o nombre">
        </div>
        <table id="table-estudiantes" class="striped highlight">
            <thead><tr><th>Estudiante</th><th>Documento</th><th>Nombre</th><th>Estado</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${estudiantes}">
                <tr class="select-row" data-select="ID_ESTUDIANTE" data-value="${item['ID_ESTUDIANTE']}">
                    <td>${item['ID_ESTUDIANTE']}</td><td>${item['DOCUMENTO']}</td><td>${item['NOMBRE']}</td><td>${item['ESTADO']}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="modal-footer"><button type="button" class="modal-close btn-flat">Cerrar</button></div>
</div>

<div id="modal-cursos" class="modal">
    <div class="modal-content">
        <h5>Seleccionar curso</h5>
        <div class="input-field modal-search">
            <i class="material-icons prefix">search</i>
            <input type="text" class="lookup-search" data-table="table-cursos" placeholder="Buscar por código o nombre">
        </div>
        <table id="table-cursos" class="striped highlight">
            <thead><tr><th>Curso</th><th>Código</th><th>Nombre</th><th>Créditos</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${cursos}">
                <tr class="select-row" data-select="ID_CURSO" data-value="${item['ID_CURSO']}">
                    <td>${item['ID_CURSO']}</td><td>${item['CODIGO']}</td><td>${item['NOMBRE']}</td><td>${item['CREDITOS']}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="modal-footer"><button type="button" class="modal-close btn-flat">Cerrar</button></div>
</div>

<div id="modal-periodos" class="modal">
    <div class="modal-content">
        <h5>Seleccionar periodo</h5>
        <div class="input-field modal-search">
            <i class="material-icons prefix">search</i>
            <input type="text" class="lookup-search" data-table="table-periodos" placeholder="Buscar por código o nombre">
        </div>
        <table id="table-periodos" class="striped highlight">
            <thead><tr><th>Período</th><th>Código</th><th>Nombre</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${periodos}">
                <tr class="select-row" data-select="ID_PERIODO" data-value="${item['ID_PERIODO']}">
                    <td>${item['ID_PERIODO']}</td><td>${item['CODIGO']}</td><td>${item['NOMBRE']}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="modal-footer"><button type="button" class="modal-close btn-flat">Cerrar</button></div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/crud-filter.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    M.FormSelect.init(document.querySelectorAll('select'));
    M.Modal.init(document.querySelectorAll('.modal'));
    M.updateTextFields();

    document.querySelectorAll('.lookup-search').forEach(function (input) {
        input.addEventListener('input', function () {
            var query = this.value.toLocaleLowerCase('es').trim();
            document.querySelectorAll('#' + this.dataset.table + ' tbody tr').forEach(function (row) {
                row.style.display = row.textContent.toLocaleLowerCase('es').includes(query) ? '' : 'none';
            });
        });
    });

    document.querySelectorAll('.select-row').forEach(function (row) {
        row.addEventListener('click', function () {
            var select = document.getElementById(this.dataset.select);
            select.value = this.dataset.value;
            M.FormSelect.init(select);
            M.Modal.getInstance(this.closest('.modal')).close();
        });
    });
});
</script>
</body>
</html>
