package com.cursos;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/periodos")
public class PeriodoServlet extends TableCrudServlet {
    @Override
    protected String getTableName() {
        return "PERIODOS";
    }

    @Override
    protected String getViewName() {
        return "periodos";
    }
}
