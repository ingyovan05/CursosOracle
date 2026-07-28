package com.cursos;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class OracleTableService {

    public static String formatColumnName(String columnName) {
        if (columnName == null || columnName.isBlank()) {
            return "";
        }
        String normalized = columnName.toUpperCase(Locale.ROOT);
        if (normalized.startsWith("ID_")) {
            normalized = normalized.substring(3);
        }
        return switch (normalized) {
            case "INSCRIPCION" -> "Inscripción";
            case "PERIODO" -> "Período";
            case "CODIGO" -> "Código";
            case "CREDITOS" -> "Créditos";
            case "FECHA_INSCRIPCION" -> "Fecha de inscripción";
            default -> {
                String text = normalized.replace('_', ' ').toLowerCase(Locale.ROOT);
                yield Character.toUpperCase(text.charAt(0)) + text.substring(1);
            }
        };
    }

    public List<TableColumn> getColumns(String tableName) throws SQLException {
        List<TableColumn> columns = new ArrayList<>();
        String sql = "SELECT column_name, data_type, nullable FROM user_tab_columns WHERE table_name = ? ORDER BY column_id";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableName.toUpperCase(Locale.ROOT));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    columns.add(new TableColumn(rs.getString("column_name"), rs.getString("data_type"), "Y".equalsIgnoreCase(rs.getString("nullable"))));
                }
            }
        }
        return columns;
    }

    public String getPrimaryKeyColumn(List<TableColumn> columns) throws SQLException {
        if (columns.isEmpty()) {
            return null;
        }
        String sql = "SELECT cc.column_name FROM user_constraints uc JOIN user_cons_columns cc ON uc.constraint_name = cc.constraint_name WHERE uc.table_name = ? AND uc.constraint_type = 'P' ORDER BY cc.position";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, columns.get(0).getTableName().toUpperCase(Locale.ROOT));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        }
        for (TableColumn col : columns) {
            String key = col.getColumnName().toUpperCase(Locale.ROOT);
            if (key.contains("ID") || key.contains("CODIGO")) {
                return col.getColumnName();
            }
        }
        return columns.get(0).getColumnName();
    }

    public List<Map<String, Object>> listRows(String tableName) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        String sql = "SELECT * FROM \"" + tableName.toUpperCase(Locale.ROOT) + "\"";
        try (Connection conn = DbConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                    row.put(rs.getMetaData().getColumnLabel(i), rs.getObject(i));
                }
                rows.add(row);
            }
        }
        return rows;
    }

    public Map<String, Object> getRow(String tableName, String pkColumnName, String pkValue) throws SQLException {
        String sql = "SELECT * FROM \"" + tableName.toUpperCase(Locale.ROOT) + "\" WHERE \"" + pkColumnName.toUpperCase(Locale.ROOT) + "\" = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, pkValue);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                        row.put(rs.getMetaData().getColumnLabel(i), rs.getObject(i));
                    }
                    return row;
                }
            }
        }
        return null;
    }

    public boolean exists(String tableName, String pkColumnName, String pkValue) throws SQLException {
        String sql = "SELECT 1 FROM \"" + tableName.toUpperCase(Locale.ROOT) + "\" WHERE \"" + pkColumnName.toUpperCase(Locale.ROOT) + "\" = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, pkValue);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void insertRow(String tableName, List<TableColumn> columns, Map<String, String> values) throws SQLException {
        List<TableColumn> insertColumns = new ArrayList<>();
        for (TableColumn column : columns) {
            String raw = values.get(column.getColumnName());
            if (raw != null && !raw.isBlank()) {
                insertColumns.add(column);
            }
        }
        if (insertColumns.isEmpty()) {
            throw new SQLException("No hay datos para insertar");
        }
        StringBuilder sql = new StringBuilder("INSERT INTO \"").append(tableName.toUpperCase(Locale.ROOT)).append("\" (");
        for (int i = 0; i < insertColumns.size(); i++) {
            if (i > 0) {
                sql.append(", ");
            }
            sql.append("\"").append(insertColumns.get(i).getColumnName().toUpperCase(Locale.ROOT)).append("\"");
        }
        sql.append(") VALUES (");
        for (int i = 0; i < insertColumns.size(); i++) {
            if (i > 0) {
                sql.append(", ");
            }
            sql.append("?");
        }
        sql.append(")");
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < insertColumns.size(); i++) {
                TableColumn column = insertColumns.get(i);
                ps.setObject(i + 1, prepareValue(column, values.get(column.getColumnName())));
            }
            ps.executeUpdate();
        }
    }

    public void updateRow(String tableName, List<TableColumn> columns, Map<String, String> values, String pkColumnName) throws SQLException {
        List<TableColumn> editableColumns = new ArrayList<>();
        for (TableColumn column : columns) {
            if (!column.getColumnName().equalsIgnoreCase(pkColumnName)) {
                String raw = values.get(column.getColumnName());
                if (raw != null) {
                    editableColumns.add(column);
                }
            }
        }
        if (editableColumns.isEmpty()) {
            throw new SQLException("No hay columnas para actualizar");
        }
        StringBuilder sql = new StringBuilder("UPDATE \"").append(tableName.toUpperCase(Locale.ROOT)).append("\" SET ");
        for (int i = 0; i < editableColumns.size(); i++) {
            if (i > 0) {
                sql.append(", ");
            }
            sql.append("\"").append(editableColumns.get(i).getColumnName().toUpperCase(Locale.ROOT)).append("\" = ?");
        }
        sql.append(" WHERE \"").append(pkColumnName.toUpperCase(Locale.ROOT)).append("\" = ?");
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (TableColumn column : editableColumns) {
                ps.setObject(index++, prepareValue(column, values.get(column.getColumnName())));
            }
            ps.setObject(index, values.get(pkColumnName));
            ps.executeUpdate();
        }
    }

    public void deleteRow(String tableName, String pkColumnName, String pkValue) throws SQLException {
        String sql = "DELETE FROM \"" + tableName.toUpperCase(Locale.ROOT) + "\" WHERE \"" + pkColumnName.toUpperCase(Locale.ROOT) + "\" = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, pkValue);
            ps.executeUpdate();
        }
    }

    private Object prepareValue(TableColumn column, String rawValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return null;
        }
        String type = column.getDataType().toUpperCase(Locale.ROOT);
        if (type.contains("NUMBER")) {
            return new BigDecimal(rawValue);
        }
        if (type.contains("DATE") || type.contains("TIMESTAMP")) {
            return Timestamp.valueOf(rawValue.replace("T", " "));
        }
        return rawValue;
    }

    public static class TableColumn {
        private final String columnName;
        private final String dataType;
        private final boolean nullable;
        private final String tableName;

        public TableColumn(String columnName, String dataType, boolean nullable) {
            this.columnName = columnName;
            this.dataType = dataType;
            this.nullable = nullable;
            this.tableName = null;
        }

        public TableColumn(String columnName, String dataType, boolean nullable, String tableName) {
            this.columnName = columnName;
            this.dataType = dataType;
            this.nullable = nullable;
            this.tableName = tableName;
        }

        public String getColumnName() {
            return columnName;
        }

        public String getDisplayName() {
            return formatColumnName(columnName);
        }

        public String getDataType() {
            return dataType;
        }

        public boolean isNullable() {
            return nullable;
        }

        public String getTableName() {
            return tableName != null ? tableName : "";
        }
    }
}
