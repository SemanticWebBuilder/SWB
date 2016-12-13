<%@page import="org.semanticwb.resources.sem.forumcat.SWBForumCatResource"%>
<%@page import="org.semanticwb.resources.sem.forumcat.Question"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURLImp"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.resources.sem.forumcat.QuestionSubscription"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Locale"%>

<%!
public static int MAX_PENDIENTES_STRATEGY = 4;
public static int MAX_CHARS = 50;
%>

<%!
 class SuscriptionComparator implements Comparator<QuestionSubscription> {
     private User usr;
     public void setUser(User user) {
        usr = user;
     }
     
     public int compare(QuestionSubscription qs1, QuestionSubscription qs2) {
        Question q1 = qs1.getQuestionObj();
        Question q2 = qs2.getQuestionObj();
        int ret = -1;
        if (q2.userHasAnswered(usr) && !q1.userHasAnswered(usr)) {
            ret = -1;
        } else if (!q2.userHasAnswered(usr) && q1.userHasAnswered(usr)) {
            ret = 1;
        } else if (q2.userHasAnswered(usr) == q1.userHasAnswered(usr)) {
            ret = 0;
        }
        return ret;
    }
 }
%>
<%
SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
SimpleDateFormat dateFormat;
SimpleDateFormat iso8601dateFormat;
DecimalFormat df = new java.text.DecimalFormat("#0.0#");
SWBResourceURL pageURL = paramRequest.getRenderUrl();

String lang = "es";
Locale locale = new Locale(lang);
dateFormat = new SimpleDateFormat("yyyy-MMM-dd", locale);
String[] months = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};

java.text.DateFormatSymbols fs = dateFormat.getDateFormatSymbols();
fs.setShortMonths(months);
dateFormat.setDateFormatSymbols(fs);
String defaultFormat = "d 'de' MMMM 'del' yyyy";
iso8601dateFormat = new SimpleDateFormat(defaultFormat, locale);

User user = paramRequest.getUser();
String baseImg = SWBPortal.getWebWorkPath()+"/models/"+paramRequest.getWebPage().getWebSiteId()+"/css/images/";
WebPage wp = paramRequest.getWebPage().getWebSite().getWebPage("Cafeteria");
ArrayList<QuestionSubscription> questions = (ArrayList<QuestionSubscription>) request.getAttribute("listSubscriptions");

SuscriptionComparator c = new SuscriptionComparator();
c.setUser(user);
Collections.sort(questions, c);
boolean paginate = false;

String styles[] = {"post_responder_1", "post_contestaron_1", "post_responder_2", "post_contestaron_2", "post_responder_3", "post_contestaron_3", "post_responder_4", "post_contestaron_4"};

if (paramRequest.getCallMethod() == paramRequest.Call_STRATEGY) {
    %>
    <div id="pendientes">
        <div class="ver_mas">
            <a href="/swb/<%=wp.getWebSiteId()%>/Pendientes"><img src="<%=baseImg%>/transparente.gif" alt="Ver más" width="70" height="30"></a>
        </div>
    <%
    if (user.isSigned()) {
        if (questions != null && !questions.isEmpty()) {
            paginate = true;
            Iterator<QuestionSubscription> it_q = questions.iterator();
            if (it_q.hasNext()) {
                QuestionSubscription qs = it_q.next();
                if (qs.getQuestionObj().getQueStatus() == SWBForumCatResource.STATUS_ACEPTED) {
                    SWBResourceURL delUrl = paramRequest.getActionUrl().setAction("deleteSubscription").setParameter("uri", qs.getEncodedURI());
                    SWBResourceURL url = new SWBResourceURLImp(request, qs.getQuestionObj().getForumResource().getResource(), wp, SWBResourceURL.UrlType_RENDER);
                    String name = qs.getQuestionObj().getQuestion().replaceAll("(<a[^>]*?href\\s*=\\s*((\'|\")(.*?)(\'|\"))[^>]*?(?!/)>)|</a>", "");
                    if (name.length() > MAX_CHARS) {
                        name = name.substring(0, MAX_CHARS) + "...";
                    }
                    url.setAction("answerQuestion");
                    url.setParameter("uri", qs.getQuestionObj().getURI());
                    %>
                    <div class="postitTop">
                        <p class="titulo"><%=(qs.getQuestionObj().userHasAnswered(user)?"Has respondido:":"Por responder:")%></p>
                        <p><%=name%></p>
                        <p class="dato"><%=iso8601dateFormat.format(qs.getQuestionObj().getCreated())%></p>
                        <ul class="menu_pendiente">
                            <li>
                                <a class="vinculo" href="<%=url%>">Responder</a>
                            </li>
                            <li>
                                <a class="vinculo" href="<%=delUrl%>">Eliminar</a>
                            </li>
                        </ul>
                    </div>
                    <%
                }
            }
            if (it_q.hasNext()) {
                QuestionSubscription qs = it_q.next();
                if (qs.getQuestionObj().getQueStatus() == SWBForumCatResource.STATUS_ACEPTED) {
                    SWBResourceURL delUrl = paramRequest.getActionUrl().setAction("deleteSubscription").setParameter("uri", qs.getEncodedURI());
                    SWBResourceURL url = new SWBResourceURLImp(request, qs.getQuestionObj().getForumResource().getResource(), wp, SWBResourceURL.UrlType_RENDER);
                    String name = qs.getQuestionObj().getQuestion().replaceAll("(<a[^>]*?href\\s*=\\s*((\'|\")(.*?)(\'|\"))[^>]*?(?!/)>)|</a>", "");
                    if (name.length() > MAX_CHARS) {
                        name = name.substring(0, MAX_CHARS) + "...";
                    }
                    url.setAction("answerQuestion");
                    url.setParameter("uri", qs.getQuestionObj().getURI());
                    %>
                    <div class="postitTopDer">
                        <p class="titulo"><%=(qs.getQuestionObj().userHasAnswered(user)?"Has respondido:":"Por responder:")%></p>
                        <p><%=name%></p>
                        <p class="dato"><%=iso8601dateFormat.format(qs.getQuestionObj().getCreated())%></p>
                        <ul class="menu_pendiente">
                            <li>
                                <a class="vinculo" href="<%=url%>">Responder</a>
                            </li>
                            <li>
                                <a class="vinculo" href="<%=delUrl%>">Eliminar</a>
                            </li>
                        </ul>
                    </div>
                    <%
                }
            }
            if (it_q.hasNext()) {
                QuestionSubscription qs = it_q.next();
                if (qs.getQuestionObj().getQueStatus() == SWBForumCatResource.STATUS_ACEPTED) {
                    SWBResourceURL delUrl = paramRequest.getActionUrl().setAction("deleteSubscription").setParameter("uri", qs.getEncodedURI());
                    SWBResourceURL url = new SWBResourceURLImp(request, qs.getQuestionObj().getForumResource().getResource(), wp, SWBResourceURL.UrlType_RENDER);
                    String name = qs.getQuestionObj().getQuestion().replaceAll("(<a[^>]*?href\\s*=\\s*((\'|\")(.*?)(\'|\"))[^>]*?(?!/)>)|</a>", "");
                    if (name.length() > MAX_CHARS) {
                        name = name.substring(0, MAX_CHARS) + "...";
                    }
                    url.setAction("answerQuestion");
                    url.setParameter("uri", qs.getQuestionObj().getURI());
                    %>
                    <div class="postitBot">
                        <p class="titulo"><%=(qs.getQuestionObj().userHasAnswered(user)?"Has respondido:":"Por responder:")%></p>
                        <p><%=name%></p>
                        <p class="dato"><%=iso8601dateFormat.format(qs.getQuestionObj().getCreated())%></p>
                        <ul class="menu_pendiente">
                            <li>
                                <a class="vinculo" href="<%=url%>">Responder</a>
                            </li>
                            <li>
                                <a class="vinculo" href="<%=delUrl%>">Eliminar</a>
                            </li>
                        </ul>
                    </div>
                    <%
                }
            }
            if (it_q.hasNext()) {
                QuestionSubscription qs = it_q.next();
                if (qs.getQuestionObj().getQueStatus() == SWBForumCatResource.STATUS_ACEPTED) {
                    SWBResourceURL delUrl = paramRequest.getActionUrl().setAction("deleteSubscription").setParameter("uri", qs.getEncodedURI());
                    SWBResourceURL url = new SWBResourceURLImp(request, qs.getQuestionObj().getForumResource().getResource(), wp, SWBResourceURL.UrlType_RENDER);
                    String name = qs.getQuestionObj().getQuestion().replaceAll("(<a[^>]*?href\\s*=\\s*((\'|\")(.*?)(\'|\"))[^>]*?(?!/)>)|</a>", "");
                    if (name.length() > MAX_CHARS) {
                        name = name.substring(0, MAX_CHARS) + "...";
                    }
                    url.setAction("answerQuestion");
                    url.setParameter("uri", qs.getQuestionObj().getURI());
                    %>
                    <div class="postitBotDer">
                        <p class="titulo"><%=(qs.getQuestionObj().userHasAnswered(user)?"Has respondido:":"Por responder:")%></p>
                        <p><%=name%></p>
                        <p class="dato"><%=iso8601dateFormat.format(qs.getQuestionObj().getCreated())%></p>
                        <ul class="menu_pendiente">
                            <li>
                                <a class="vinculo" href="<%=url%>">Responder</a>
                            </li>
                            <li>
                                <a class="vinculo" href="<%=delUrl%>">Eliminar</a>
                            </li>
                        </ul>
                    </div>
                    <%
                }
            }
        }
    }
    %></div><%
} else if (paramRequest.getCallMethod() == paramRequest.Call_CONTENT) {
    int recPerPage = 8; //TODO: poner el numero de registros por paginas en la administracion
    int nRec = 0;
    int nPage;
    try {
        nPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception ignored) {
         nPage = 1;
    }
    %>
    <div class="corcho">
    <%
    if (user.isSigned()) {
        int idx = 0;
        Iterator<QuestionSubscription> it_q = questions.iterator();
        while (it_q.hasNext()) {
            QuestionSubscription qs = it_q.next();
            if (qs.getQuestionObj().getQueStatus() == SWBForumCatResource.STATUS_ACEPTED) {
                nRec++;
                if ((nRec > (nPage - 1) * recPerPage) && (nRec <= (nPage) * recPerPage)) {
                    SWBResourceURL delUrl = paramRequest.getActionUrl().setAction("deleteSubscription").setParameter("uri", qs.getEncodedURI());
                    SWBResourceURL url = new SWBResourceURLImp(request, qs.getQuestionObj().getForumResource().getResource(), wp, SWBResourceURL.UrlType_RENDER);
                    String name = qs.getQuestionObj().getQuestion().replaceAll("(<a[^>]*?href\\s*=\\s*((\'|\")(.*?)(\'|\"))[^>]*?(?!/)>)|</a>", "");
                    if (name.length() > MAX_CHARS) {
                        name = name.substring(0, MAX_CHARS) + "...";
                    }
                    url.setAction("answerQuestion");
                    url.setParameter("uri", qs.getQuestionObj().getURI());
                    %>
                    <div class="<%=styles[idx++]%>">
                        <p class="titulo"><%=(qs.getQuestionObj().userHasAnswered(user)?"Has respondido:":"Por responder:")%></p>
                        <p class="post_texto"><%=name%></p>
                        <p class="dato"><%=iso8601dateFormat.format(qs.getQuestionObj().getCreated())%></p>
                        <ul class="menu_pendiente">
                            <li>
                                <a class="vinculo" href="<%=url%>">Responder</a>
                            </li>
                            <li>
                                <a class="vinculo" href="<%=delUrl%>">Eliminar</a>
                            </li>
                        </ul>
                    </div>
                    <%
                }
            }
        }
        %>        
        </div>
        <%
        if (paginate) {
            %>
            <div id="paginacion">
                <span>P&aacute;ginas:</span>
                <ul>
                    <%
                    for (int countPage = 1; countPage < (Math.ceil((double) nRec / (double) recPerPage) + 1); countPage++) {
                        pageURL.setParameter("page", "" + (countPage));
                        if (countPage == nPage) {
                            %><li><a class="selected" href="<%=pageURL%>"><%=countPage%></a></li><%
                        } else {
                            %><li><a href="<%=pageURL%>"><%=countPage%></a></li>&nbsp;<%
                        }
                    }%>
                </ul>
            </div>
           <%
        }
    }
}
%>