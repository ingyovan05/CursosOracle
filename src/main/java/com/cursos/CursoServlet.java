package com.cursos;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/cursos")
public class CursoServlet extends TableCrudServlet {
    @Override
    protected String getTableName() {
        return "CURSOS";
    }

    @Override
    protected String getViewName() {
        return "cursos";
    }
}
