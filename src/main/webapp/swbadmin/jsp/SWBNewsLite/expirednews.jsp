<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    List<New> news=(List) request.getAttribute("news");
    if(news.isEmpty())
        {
        %>
        <p>No hay noticias expiradas</p>
        <%
        return;
        }    
%>

<script type="text/javascript">
    <!--
    function validateremove(url, title,uri)
    {
        if(confirm('¿Esta seguro de borrar la noticia con título '+title+'?'))
        {
            var url=url+'&amp;uri='+escape(uri);
            window.location.href=url;
        }
    }
    -->
</script>
<div class="columnaIzquierda">
 <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN)%>">Cancelar</a>
    </div>
    <h1>Noticias expiradas</h1><br>
    <table cellpadding="2" cellspacing="2">
        <tr>
            <th>
                Imagen
            </th>
            <th>
            Fecha de creación
            </th>
            <th>
            Fecha de expiración
            </th>
            <th>
            Título
            </th>
            <th>
            Editar
            </th>
            <th>
            Eliminar
            </th>
            </tr>
    <%
    SimpleDateFormat formatview = new SimpleDateFormat("dd/MM/yyy HH:mm:ss");
    for(New onew : news)
    {
        String title=onew.getTitle();        
        String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNewsLite/sinfoto.png";
        String editarImg = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNewsLite/editar.png";
        String eliminarImg = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNewsLite/eliminar.png";
        String path = onew.getWorkPath();
        if (onew.getNewsThumbnail() != null)
        {
            int pos = onew.getNewsThumbnail().lastIndexOf("/");
            if (pos != -1)
            {
                String sphoto = onew.getNewsThumbnail().substring(pos + 1);
                onew.setNewsThumbnail(sphoto);
            }
            pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + onew.getNewsThumbnail();
        }
        SWBResourceURL  urlEdit=paramRequest.getRenderUrl();
        urlEdit.setParameter("uri", onew.getURI());
        urlEdit.setMode("edit");

        SWBResourceURL  removeUrl=paramRequest.getActionUrl();
        removeUrl.setParameter("uri", onew.getEncodedURI());
        removeUrl.setParameter("act", "remove");
        String created=formatview.format(onew.getCreated());
        String expireted=formatview.format(onew.getExpiration());

        String deleteUrl = "javascript:validateremove('" + removeUrl + "','" + onew.getTitle() + "','" + onew.getURI() + "')";
        %>
        <tr>
            <td align="center">
                <img width="20"  height="20" alt="Imagen noticia" src="<%=pathPhoto%>" />
            </td>
            <td>
            <%=created%>
            </td>
             <td>
            <%=expireted%>
            </td>
            <td>
            <%=title%>
            </td>           
            <td align="center">
                <a href="<%=urlEdit%>"><img width="20"  height="20" alt="Imagen noticia" src="<%=editarImg%>" /></a>
            </td>
            <td align="center">
                <a href="<%=deleteUrl%>"><img width="20"  height="20" alt="Imagen noticia" src="<%=eliminarImg%>" /></a>
            </td>
            </tr>
        <%
    }
    %>
    </table>
    <%

%>

 <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN)%>">Cancelar</a>
    </div>
</div>