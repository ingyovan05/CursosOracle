package com.cursos;

import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public abstract class TableCrudServlet extends HttpServlet {

    protected abstract String getTableName();

    protected abstract String getViewName();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            OracleTableService service = new OracleTableService();
            List<OracleTableService.TableColumn> columns = service.getColumns(getTableName());
            String pkColumnName = service.getPrimaryKeyColumn(columns);
            List<Map<String, Object>> rows = service.listRows(getTableName());
            req.setAttribute("tableName", getTableName());
            req.setAttribute("columns", columns);
            req.setAttribute("pkColumnName", pkColumnName);
            req.setAttribute("rows", rows);
            populateViewData(req, service);

            String action = req.getParameter("action");
            String id = req.getParameter("id");
            if ("editar".equalsIgnoreCase(action) && id != null && !id.isBlank()) {
                req.setAttribute("selectedRow", service.getRow(getTableName(), pkColumnName, id));
            }
            req.getRequestDispatcher("/" + getViewName() + ".jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("No se pudo consultar la tabla " + getTableName(), e);
        }
    }

    protected void populateViewData(HttpServletRequest req, OracleTableService service) throws SQLException {
        // Las pantallas especializadas pueden agregar catálogos al formulario.
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            OracleTableService service = new OracleTableService();
            List<OracleTableService.TableColumn> columns = service.getColumns(getTableName());
            String pkColumnName = service.getPrimaryKeyColumn(columns);
            Map<String, String> values = new LinkedHashMap<>();
            for (OracleTableService.TableColumn column : columns) {
                values.put(column.getColumnName(), req.getParameter(column.getColumnName()));
            }
            String action = req.getParameter("action");
            if ("eliminar".equalsIgnoreCase(action)) {
                service.deleteRow(getTableName(), pkColumnName, req.getParameter("id"));
            } else {
                String pkValue = values.get(pkColumnName);
                if (pkValue != null && !pkValue.isBlank() && service.exists(getTableName(), pkColumnName, pkValue)) {
                    service.updateRow(getTableName(), columns, values, pkColumnName);
                } else {
                    service.insertRow(getTableName(), columns, values);
                }
            }
            resp.sendRedirect(req.getContextPath() + "/" + getViewName());
        } catch (SQLException e) {
            throw new ServletException("No se pudo procesar la operación en la tabla " + getTableName(), e);
        }
    }
}
