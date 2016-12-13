<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.platform.*"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>

<%!

public int calcularEdad(java.util.Calendar fechaNaci, java.util.Calendar fechaAlta){

        int diff_año =fechaAlta.get(java.util.Calendar.YEAR)-
        fechaNaci.get(java.util.Calendar.YEAR);
        int diff_mes = fechaAlta.get(java.util.Calendar.MONTH)- fechaNaci.get(java.util.Calendar.MONTH);
        int diff_dia = fechaAlta.get(java.util.Calendar.DATE)-fechaNaci.get(java.util.Calendar.DATE);
        if(diff_mes<0 ||(diff_mes==0 && diff_dia<0)){
            diff_año =diff_año-1;
        }
        return diff_año;
    }

%>

<%
            User owner = paramRequest.getUser();
            User user = owner;
            if (request.getParameter("user") != null)
            {
                SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                user = (User) semObj.createGenericInstance();
            }
            String userParam = "";
            if (owner != user)
            {
                userParam = "?user=" + user.getEncodedURI();
            }

            WebPage wpage = paramRequest.getWebPage();
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
            SWBResourceURL urlAction = paramRequest.getActionUrl();

            String perfilPath = paramRequest.getWebPage().getWebSite().getWebPage("perfil").getUrl();
            String requestedPath = paramRequest.getWebPage().getWebSite().getWebPage("mis_solicitudes").getUrl();

            String photo = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/perfil/profilePlaceholder.jpg";
            boolean isStrategy = false;
            if (paramRequest.getCallMethod() == paramRequest.Call_STRATEGY)
            {
                isStrategy = true;
            }



            HashMap<String, User> elements = new HashMap();



            Iterator<FriendshipProspect> itFriendshipProspect = FriendshipProspect.ClassMgr.listFriendshipProspectByFriendShipRequester(owner, wpage.getWebSite());
            while (itFriendshipProspect.hasNext())
            {
                FriendshipProspect friendshipProspect = itFriendshipProspect.next();
                if (friendshipProspect != null)
                {
                    User userRequested = friendshipProspect.getFriendShipRequested();
                    if (userRequested != null && userRequested.getURI() != null)
                    {
                        elements.put(userRequested.getURI(), userRequested);
                    }
                }
            }
            int elementos = elements.size();
            boolean hasRequest = elements.size() > 0;
            int paginas = elementos / ELEMENETS_BY_PAGE;
            if (elementos % ELEMENETS_BY_PAGE != 0)
            {
                paginas++;
            }
            int inicio = 0;
            int fin = ELEMENETS_BY_PAGE;
            int ipage = 1;
            if (request.getParameter("ipage") != null)
            {
                try
                {
                    ipage = Integer.parseInt(request.getParameter("ipage"));
                    inicio = (ipage * ELEMENETS_BY_PAGE) - ELEMENETS_BY_PAGE;
                    fin = (ipage * ELEMENETS_BY_PAGE);
                }
                catch (NumberFormatException nfe)
                {
                    ipage = 1;
                }
            }
            if (ipage < 1 || ipage > paginas)
            {
                ipage = 1;
            }
            if (inicio < 0)
            {
                inicio = 0;
            }
            if (fin < 0)
            {
                fin = ELEMENETS_BY_PAGE;
            }
            if (fin > elementos)
            {
                fin = elementos;
            }
            if (inicio > fin)
            {
                inicio = 0;
                fin = ELEMENETS_BY_PAGE;
            }
            if (fin - inicio > ELEMENETS_BY_PAGE)
            {
                inicio = 0;
                fin = ELEMENETS_BY_PAGE;
            }
            inicio++;
            if (elements.size() > 0)
            {
                hasRequest = true;
            }
%>
<!-- paginacion -->
<%
            if (paginas > 1 && !isStrategy)
            {
%>
<div class="paginacion">


    <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
    %>
    <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
        <%
                }
                for (int i = 1; i <= paginas; i++)
                {
        %>
    <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
                    if (i == ipage)
                    {
        %>
        <strong>
            <%                            }
            %>
            <%=i%>
            <%
                    if (i == ipage)
                    {
            %>
        </strong>
        <%                            }
        %></a>
    <%
                }
    %>


    <%
                if (ipage != paginas)
                {
    %>
    <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
        <%
                }
        %>
</div>
<%
            }
%>
<!-- fin paginacion -->


<%
            if (request.getParameter("user") == null)
            {
%>

<h2>Mis solicitudes</h2>
<%
                if (!hasRequest)
                {
%>
<ul class="listaElementos">
    <li>
        <a class="contactos_nombre" href="#">No has solicitado personas que se unan a ti como amigos.</a>
    </li>
</ul>
<%                }
            }
%>

<%
            if (hasRequest)
            {
%>


<%
                //itFriendshipProspect = FriendshipProspect.ClassMgr.listFriendshipProspectByFriendShipRequester(owner, wpage.getWebSite());
                if (!isStrategy)
                {
%>
<div id="friendCards">
    <%                }
                int iElement = 0;
                Collection<User> users = elements.values();
                for (User userRequested : users)
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        photo = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/perfil/profilePlaceholder.jpg";
                        if (userRequested.getPhoto() != null)
                        {
                            photo = SWBPortal.getWebWorkPath() + userRequested.getPhoto();
                        }
                        urlAction.setParameter("user", userRequested.getURI());
                        if (!isStrategy)
                        {
                            String path = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSite().getId() + "/css/images/";
                            String urluser = java.net.URLEncoder.encode(userRequested.getURI());
                            String email = userRequested.getEmail();
                            HashMap<String, SemanticProperty> mapa = new HashMap<String, SemanticProperty>();
                            Iterator<SemanticProperty> list = org.semanticwb.SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass("http://www.semanticwebbuilder.org/swb4/community#_ExtendedAttributes").listProperties();
                            while (list.hasNext())
                            {
                                SemanticProperty prop = list.next();
                                mapa.put(prop.getName(), prop);
                            }
                            String perfilurl = paramRequest.getWebPage().getWebSite().getWebPage("perfil").getUrl();
                            if (request.getParameter("user") != null)
                            {
                                perfilurl += "?user=" + java.net.URLEncoder.encode(request.getParameter("user"));
                            }
                            String usr_sex = (String) userRequested.getExtendedAttribute(mapa.get("userSex"));
                            if (usr_sex == null)
                            {
                                usr_sex = "No indicó el usuario su sexo";
                            }
                            String age = "";
                            if (userRequested.getExtendedAttribute(mapa.get("userBirthDate")) != null)
                            {
                                age = "" + userRequested.getExtendedAttribute(mapa.get("userBirthDate"));
                            }

                            if (age == null)
                            {
                                age = "Sin edad";
                            }
                            if (!age.equals(""))
                            {
                                java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                                Date date = df.parse(age.toString());
                                java.util.Calendar cal1 = java.util.Calendar.getInstance();
                                cal1.setTime(date);

                                java.util.Calendar cal2 = java.util.Calendar.getInstance();
                                cal2.setTime(new Date(System.currentTimeMillis()));
                                age = "" + calcularEdad(cal1, cal2);
                            }
                            if ("M".equals(usr_sex))
                            {
                                usr_sex = "Hombre";
                            }
                            if ("F".equals(usr_sex))
                            {
                                usr_sex = "Mujer";
                            }
                            if (age.toString().equals("0") || age.toString().equals(""))
                            {
                                age = "No indicó el usuario";
                            }

    %>

    <div class="friendCard">
        <img class="profilePic" width="121" height="121" src="<%=photo%>" alt="<%=userRequested.getFullName()%>"/>
        <div class="friendCardInfo">            
            <%
                            if (userRequested.getEmail() != null)
                            {
            %>
            <a class="ico" href="mailto:<%=email%>"><img src="<%=path%>icoMail.png" alt="enviar un mensaje"/></a>
                <%
                            }
                %>


            <a class="ico" href="<%=perfilurl%>?user=<%=urluser%>"><img src="<%=path%>icoUser.png" alt="ir al perfil"/></a>
            <div class="friendCardName">
                <p><%=userRequested.getFullName()%></p>
            </div>
            <p>Sexo:<%=usr_sex%></p>
            <p>Edad:<%=age%></p>
            <%urlAction.setAction("removeRequest");%>
            <p><a href="<%=urlAction%>">[Eliminar solicitud]</a></p>
        </div>
    </div>

    <%
                        }
                    }
                }
                if (!isStrategy)
                {
    %>
</div>


<%                }
                if (isStrategy && elementos > 0)
                {
%>

<%
                    if (request.getParameter("user") == null)
                    {
%>
<ul class="listaElementos">
    <li>
        <a class="contactos_nombre" href="<%=requestedPath%><%=userParam%>">Has solicidado a <%=elementos%> personas que se unan como tus amigos</a>
    </li>
</ul>
<%
                    }
%>        


<%}
                else if (elementos == 0)
                {
%>
<!-- <ul class="listaElementos">
    <li>
        <a class="contactos_nombre" href="#">No has solicitado personas que se unan a ti como amigos.</a>
    </li>
</ul> -->

<%            }
%>

<%
            }
            else
            {
%>
<!-- <ul class="listaElementos">
    <li>
        <a class="contactos_nombre" href="#">No has solicitado personas que se unan a ti como amigos.</a>
    </li>
</ul> -->
<%            }

%>

