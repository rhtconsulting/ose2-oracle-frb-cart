<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<sql:query var="rs" dataSource="jdbc/OracleDS">
SELECT SYSDATE FROM DUAL
</sql:query>

<html>
  <head>
    <title>DB Test</title>
  </head>
  <body>

  <h2>Results</h2>
     Successfully confirmed connection to "jdbc/OracleDS" via a "SELECT SYSDATA FROM DUAL" query<br/>
     <c:forEach var="row" items="${rs.rows}">
          SYSDATE Returned from query: ${row.SYSDATE}<br/>
     </c:forEach>
  </body>
</html>
