<%@page contentType="text/html" %>
<%@page import="java.util.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="org.semanticwb.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.portal.resources.sem.favoriteWebPages.*"%>
<%@page import="static org.semanticwb.portal.resources.sem.favoriteWebPages.SWBFavoriteWebPagesResource.*"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
    StringBuilder services = new StringBuilder();
    StringBuilder favorites = new StringBuilder();
    WebPage enLinea = paramRequest.getWebPage().getWebSite().getWebPage("En_linea");

    final User user = paramRequest.getUser();
    final String lang = user.getLanguage();
    Iterator<SWBFavoriteWebPage> it = SWBFavoriteWebPage.ClassMgr.listSWBFavoriteWebPageByUser(user, paramRequest.getWebPage().getWebSite());
    List<SWBFavoriteWebPage> list = SWBUtils.Collections.copyIterator(it);
    Collections.sort(list);
    Collections.reverse(list);

    String title, desc, surl;
    WebPage _page;
    for(int i=0; i<list.size(); i++)
    {
        SWBFavoriteWebPage f = list.get(i);
        _page = f.getFavorite();
        title = SWBUtils.TEXT.encodeExtendedCharacters(_page.getDisplayTitle(lang));
        desc = SWBUtils.TEXT.encodeExtendedCharacters(_page.getDisplayDescription(lang));
        surl = _page.getUrl();
%>
            <!--li><a href="<%=surl%>" ><%=title%></a></li-->
<%
        if( _page.getParent()==enLinea ) {
            services.append("<p class=\"pSubP\"><a href=\""+surl+"\" title=\""+title+"\">"+title+"</a></p>\n");
            services.append("<p>"+desc+"</p>\n");
            services.append("<p>&nbsp;</p>\n");
            //services.append("<li><a href=\""+surl+"\" title=\""+title+"\">"+title+"</a></li>\n");
        }else {
            favorites.append("<p class=\"pSubP\"><a href=\""+surl+"\" title=\""+title+"\">"+title+"</a></p>\n");
            favorites.append("<p>"+desc+"</p>\n");
            favorites.append("<p>&nbsp;</p>\n");
            //favorites.append("<li><a href=\""+surl+"\" title=\""+title+"\">"+title+"</a></li>\n");
        }
    }
    
    SWBResourceURL url = paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW);
%>
<!--li><a title="Regresar" href="<%=url%>" class="fav_cmd">Regresar</a></li-->


<div class="pModulos">
  <p class="pOcupacion">Mis Servicios favoritos</p>
  <!--p>&nbsp;</p-->
  <%=services%>
  <p><a href="#">Ver anteriores</a></p>
</div>
<div class="pModulos">
  <p class="pOcupacion">Mis Contenidos favoritos</p>
  <!--p>&nbsp;</p-->
  <%=favorites%>
  <p><a href="#">Ver anteriores</a></p>
</div>