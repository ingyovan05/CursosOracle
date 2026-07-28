package com.cursos;

import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;

@WebServlet("/inscripciones")
public class InscripcionServlet extends TableCrudServlet {
    @Override
    protected String getTableName() {
        return "INSCRIPCIONES";
    }

    @Override
    protected String getViewName() {
        return "inscripciones";
    }

    @Override
    protected void populateViewData(HttpServletRequest req, OracleTableService service) throws SQLException {
        req.setAttribute("estudiantes", service.listRows("ESTUDIANTES"));
        req.setAttribute("cursos", service.listRows("CURSOS"));
        req.setAttribute("periodos", service.listRows("PERIODOS"));
    }
}
