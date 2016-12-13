<%@page import="java.text.DateFormatSymbols"%><%@page import="java.net.*"%><%@page import="org.semanticwb.model.*"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.text.DecimalFormat"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.portal.api.SWBParamRequest"%><%@page import="org.semanticwb.resources.sem.forumcat.*"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.portal.SWBFormButton"%><%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Locale"%><%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%><%@page import="java.util.ArrayList"%><%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.SWBPlatform"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="org.semanticwb.platform.SemanticProperty"%><%@page import="org.semanticwb.resources.sem.forumcat.SWBForumCatResource"%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            String url = paramRequest.getWebPage().getUrl();
%>
<p><strong><a href="<%=url%>">Página de inicio de los foros</a></strong></p>
<%
            SWBResourceURL procesa = paramRequest.getRenderUrl();
            procesa.setAction("procesaAdd");

%>
<script type="text/javascript">
    function valida(forma)
    {
        if(!forma.title.value)
        {
            alert('¡Debe indicar el título del tema!');
            forma.title.focus();
            return;
        }
        if(confirm('¿Esta seguro de crear un tema con el título: '+ forma.title.value+'?'))
        {
            forma.submit();
        }
        
    }
</script>

<form method="post" id="add" name="add" action="<%=procesa%>">
    <p>
        <label for="txtTítulo">Título del tema:</label>
        <input type="text" value="" id="txtTítulo" name="title">
    </p>
    <p>
        <label for="txtdesc">Descripción:</label>
        <textarea id="txtdesc"  rows="10" cols="30" name="desc">&nbsp;</textarea>
    </p>
    <p>
        <input type="button" onclick="valida(this.form)" value="Agregar Tema" id="btnEnviar" name="btnEnviar">
    </p>

</form>

