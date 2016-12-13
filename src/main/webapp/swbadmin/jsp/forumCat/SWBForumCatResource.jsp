c<%@page import="org.semanticwb.base.util.SWBMail"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURLImp"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.net.*"%><%@page import="org.semanticwb.model.*"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.text.DecimalFormat"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.portal.api.SWBParamRequest"%><%@page import="org.semanticwb.resources.sem.forumcat.*"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.portal.SWBFormButton"%><%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Locale"%><%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%><%@page import="java.util.ArrayList"%><%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.SWBPlatform"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="org.semanticwb.platform.SemanticProperty"%><%@page import="org.semanticwb.resources.sem.forumcat.SWBForumCatResource"%>

<%!
    

    public static String getTimeAgo(Date CreationDate, String lang)
    {
        return getTimeAgo(new Date(), CreationDate, lang);
    }

    public static String getTimeAgo(Date CurrentDate, Date CreationDate, String lang)
    {
        SimpleDateFormat sf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        String ret = "";
        int second;
        int secondCurrent;
        int secondCreation;
        int minute;
        int minuteCurrent;
        int minuteCreation;
        int hour;
        int hourCurrent;
        int hourCreation;
        int day;
        int dayCurrent;
        int dayCreation;
        int month;
        int monthCurrent;
        int monthCreation;
        int year;
        int yearCurrent;
        int yearCreation;
        int dayMonth;

        secondCurrent = CurrentDate.getSeconds();
        secondCreation = CreationDate.getSeconds();
        minuteCurrent = CurrentDate.getMinutes();
        minuteCreation = CreationDate.getMinutes();
        hourCurrent = CurrentDate.getHours();
        hourCreation = CreationDate.getHours();
        dayCurrent = CurrentDate.getDate();
        dayCreation = CreationDate.getDate();
        monthCurrent = CurrentDate.getMonth();
        monthCreation = CreationDate.getMonth();
        yearCurrent = CurrentDate.getYear();
        yearCreation = CreationDate.getYear();

        boolean leapYear = false;
        if (monthCurrent > 1 || (dayCreation == 29 && monthCreation == 1))
        {
            leapYear = (yearCreation % 4 == 0) && (yearCreation % 100 != 0 || yearCreation % 400 == 0);
        }
        dayMonth = 0;
        day = 0;
        switch (monthCreation)
        {
            case 0:
                dayMonth = 31;
                break;
            case 1:
                if (leapYear)
                {
                    dayMonth = 29;
                }
                else
                {
                    dayMonth = 28;
                }
                break;
            case 2:
                dayMonth = 31;
                break;
            case 3:
                dayMonth = 30;
                break;
            case 4:
                dayMonth = 31;
                break;
            case 5:
                dayMonth = 30;
                break;
            case 6:
                dayMonth = 31;
                break;
            case 7:
                dayMonth = 31;
                break;
            case 8:
                dayMonth = 30;
                break;
            case 9:
                dayMonth = 31;
                break;
            case 10:
                dayMonth = 30;
                break;
            case 11:
                dayMonth = 31;
                break;
        }
        if (secondCurrent >= secondCreation)
        {
            second = secondCurrent - secondCreation;
        }
        else
        {
            second = (60 - secondCreation) + secondCurrent;
            minuteCurrent = minuteCurrent - 1;
        }
        if (minuteCurrent >= minuteCreation)
        {
            minute = minuteCurrent - minuteCreation;
        }
        else
        {
            minute = (60 - minuteCreation) + minuteCurrent;
            hourCurrent = hourCurrent - 1;
        }
        if (hourCurrent >= hourCreation)
        {
            hour = hourCurrent - hourCreation;
        }
        else
        {
            hour = (24 - hourCreation) + hourCurrent;
            dayCurrent = dayCurrent - 1;
        }
        if (dayCurrent >= dayCreation)
        {
            day = day + (dayCurrent - dayCreation);
        }
        else
        {
            day = day + ((dayMonth - dayCreation) + dayCurrent);
            monthCurrent = monthCurrent - 1;
        }
        if (monthCurrent >= monthCreation)
        {
            month = monthCurrent - monthCreation;
        }
        else
        {
            month = (12 - monthCreation) + monthCurrent;
            yearCurrent = yearCurrent - 1;
        }

        year = yearCurrent - yearCreation;
        if ("en".equals(lang))
        {
            if (year > 0)
            {
                ret = (year + " years ago");
            }
            else if (month > 0)
            {
                ret = (month + " month ago");
            }
            else if (day > 0)
            {
                ret = (day + " days ago");
            }
            else if (hour > 0)
            {
                ret = (hour + " hours ago");
            }
            else if (minute > 0)
            {
                ret = (minute + " minutes ago");
            }
            else
            {
                ret = (second + " second ago");
            }
        }
        else
        {
            if (year == 1)
            {
                ret = ("hace " + year + " año.");
            }
            else if (year > 1)
            {
                ret = ("hace " + year + " años.");
            }
            else if (month == 1)
            {
                ret = ("hace " + month + " mes.");
            }
            else if (month > 1)
            {
                ret = ("hace " + month + " meses.");
            }
            else if (day == 1)
            {
                ret = ("hace " + day + " día.");
            }
            else if (day > 1)
            {
                ret = ("hace " + day + " días.");
            }
            else if (hour == 1)
            {
                ret = ("hace " + hour + " hora.");
            }
            else if (hour > 1)
            {
                ret = ("hace " + hour + " horas.");
            }
            else if (minute == 1)
            {
                ret = ("hace " + minute + " minuto.");
            }
            else if (minute > 1)
            {
                ret = ("hace " + minute + " minutos.");
            }
            else if (second == 1)
            {
                ret = ("hace " + second + " segundo.");
            }
            else
            {
                ret = ("hace " + second + " segundos.");
            }
        }
        //ret+=" ("+sf.format(CreationDate)+")";
        ret = sf.format(CreationDate) + "";
        return ret;
    }
    private static final int MAX_RESPUESTAS = 3;

    public static String checkHTML(String html)
    {
        String[] validas =
        {
            "b", "strong", "i", "u", "em", "br"
        };
        html = html.replace("&lt;", "<");
        html = html.replace("&gt;", ">");
        String text = html;
        int pos = text.indexOf("<");
        while (pos != -1)
        {
            int pos2 = text.indexOf(">", pos);
            if (pos2 == -1)
            {
                text = text.substring(0, pos) + "&lt;" + text.substring(pos + 1);
            }
            else
            {
                String tag = text.substring(pos + 1, pos2);
                boolean valid = false;
                for (String tagvalid : validas)
                {
                    if (tag.equals(tagvalid) || tag.equals("/" + tagvalid))
                    {
                        valid = true;
                    }
                }
                if (valid)
                {
                    text = text.substring(0, pos) + "&lt;" + text.substring(pos + 1, pos2) + "&gt;" + text.substring(pos2 + 1);
                }
                else
                {
                    String tmp = text.substring(0, pos).trim();
                    String tmp2 = text.substring(pos2 + 1).trim();
                    text = tmp + " " + tmp2;
                }
            }

            pos = text.indexOf("<");
        }
        text = text.trim();
        text = text.replace("&amp;", "&");
        //text = text.replace("&lt;", "<");
        //text = text.replace("&gt;", ">");
        return text;
    }

    public String clean(String html, int size)
    {
        html = html.replace("<br />", "\n");
        html = html.replace("&lt;", "<");
        html = html.replace("&gt;", ">");
        String text = html;
        int pos = text.indexOf("<");
        while (pos != -1)
        {
            int pos2 = text.indexOf(">", pos);
            if (pos2 == -1)
            {
                text = text.substring(0, pos).trim();
            }
            else
            {
                String tmp = text.substring(0, pos).trim();
                String tmp2 = text.substring(pos2 + 1).trim();
                text = tmp + " " + tmp2;
            }
            pos = text.indexOf("<");
        }
        text = text.trim();
        if (text.length() > size)
        {
            text = text.substring(0, size) + " ...";
        }
        text = text.replace("&amp;", "&");
        return text;
    }

    public String cleanUltimo(String html)
    {

        html = html.replace("&lt;", "<");
        html = html.replace("&gt;", ">");
        String text = html;
        int pos = text.indexOf("<");
        while (pos != -1)
        {
            int pos2 = text.indexOf(">", pos);
            if (pos2 == -1)
            {
                text = text.substring(0, pos).trim();
            }
            else
            {
                String tmp = text.substring(0, pos).trim();
                String tmp2 = text.substring(pos2 + 1).trim();
                text = tmp + " " + tmp2;
            }
            pos = text.indexOf("<");
        }
        text = text.trim();
        text = text.replace("&amp;", "&");


        return text;
    }

    public String clean(String html)
    {
        html = html.replace("&lt;br /&gt;", "\n");
        html = html.replace("&lt;", "<");
        html = html.replace("&gt;", ">");
        String text = html;
        int pos = text.indexOf("<");
        while (pos != -1)
        {
            int pos2 = text.indexOf(">", pos);
            if (pos2 == -1)
            {
                text = text.substring(0, pos).trim();
            }
            else
            {
                String tmp = text.substring(0, pos).trim();
                String tmp2 = text.substring(pos2 + 1).trim();
                text = tmp + " " + tmp2;
            }
            pos = text.indexOf("<");
        }
        text = text.trim();
        text = text.replace("&amp;", "&");
        text = text.replace("\n", "<br>");

        return text;
    }

    public int getUserPoints(User user, WebSite model)
    {
        int ret = 0;
        Iterator<UserPoints> itp = UserPoints.ClassMgr.listUserPointsByPointsUser(user, model);
        while (itp.hasNext())
        {
            UserPoints up = itp.next();
            ret += up.getPoints();
        }
        return ret;
    }

    public int countUserAnswers(User user, WebSite model)
    {
        int ret = 0;
        Iterator<Answer> qit = Answer.ClassMgr.listAnswerByCreator(user, model);
        while (qit.hasNext())
        {
            ret++;
            qit.next();
        }
        return ret;
    }

    public String getVideoThumbnail(String videoUrl, WebPage wpage)
    {
        String ret = SWBPortal.getWebWorkPath() + "/models/" + wpage.getWebSiteId() + "/css/images/profilePlaceholder.jpg";
        if (videoUrl.length() > 22)
        {
            ret = "http://i.ytimg.com/vi/" + videoUrl.replaceAll("(&\\w+=.+)+", "").substring(31, videoUrl.replaceAll("(&\\w+=.+)+", "").length()) + "/default.jpg";
        }
        return ret;
    }

    public int countUserQuestions(User user, WebSite model)
    {
        int ret = 0;
        Iterator<Question> qit = Question.ClassMgr.listQuestionByCreator(user, model);
        while (qit.hasNext())
        {
            ret++;
            qit.next();
        }
        return ret;
    }
%>




<script type="text/javascript">
    var djConfig = {
        parseOnLoad: true,
        isDebug: false,
        locale: 'en-us',
        extraLocale: ['ja-jp']
    };

    function changeSecureCodeImage(id)
    {
        var img=document.getElementById(id);
        
        if(img)
        {
            img.src = '/swbadmin/jsp/securecode.jsp?time=' + new Date();
        }
    }

</script>

<script type="text/javascript">
    <!--
    var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    function decode64(input) {

        var output = "";

        var chr1, chr2, chr3 = "";

        var enc1, enc2, enc3, enc4 = "";

        var i = 0;



        // remove all characters that are not A-Z, a-z, 0-9, +, /, or =

        var base64test = /[^A-Za-z0-9\+\/\=]/g;

        if (base64test.exec(input)) {

            alert("There were invalid base64 characters in the input text.\n" +

                "Valid base64 characters are A-Z, a-z, 0-9, '+', '/',and '='\n" +

                "Expect errors in decoding.");

        }

        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");



        do {

            enc1 = keyStr.indexOf(input.charAt(i++));

            enc2 = keyStr.indexOf(input.charAt(i++));

            enc3 = keyStr.indexOf(input.charAt(i++));

            enc4 = keyStr.indexOf(input.charAt(i++));



            chr1 = (enc1 << 2) | (enc2 >> 4);

            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);

            chr3 = ((enc3 & 3) << 6) | enc4;



            output = output + String.fromCharCode(chr1);



            if (enc3 != 64) {

                output = output + String.fromCharCode(chr2);

            }

            if (enc4 != 64) {

                output = output + String.fromCharCode(chr3);

            }



            chr1 = chr2 = chr3 = "";

            enc1 = enc2 = enc3 = enc4 = "";



        } while (i < input.length);



        return unescape(output);

    }

    function closeMsg(url,text)
    {

        text=decode64(text);
        //url=checkURL(url);
        if(confirm('¿Desea cerrar el mensaje: '+text+'?'))
        {
            document.location=url;
        }

    }
    function openMsg(url,text)
    {
        text=decode64(text);
        //url=checkURL(url);
        if(confirm('¿Desea abrir de nuevo el mensaje: '+text+'?'))
        {
            document.location=url;
        }

    }
    function aproveMsg(url,text)
    {
        text=decode64(text);
        //url=checkURL(url);
        if(confirm('¿Desea aprobar el mensaje: '+text+'?'))
        {
            document.location=url;
        }

    }

    function rejectMsg2(url,text)
    {
        text=decode64(text);
        //url=checkURL(url);
        if(confirm('¿Desea rechazar el mensaje: '+ text +'?'))
        {
            document.location=url;
        }

    }
    function rejectMsg(url,text)
    {
        text=decode64(text);
        //url=checkURL(url);
        if(confirm('¿Desea dar de baja el mensaje: '+ text +'?'))
        {
            document.location=url;
        }

    }
    function deleteMsg(url,text)
    {
        text=decode64(text);
        //url=checkURL(url);
        if(confirm('¿Esta seguro de eliminar el mensaje: '+ text +'?'))
        {
            document.location=url;
        }

    }
    function checkURL(url)
    {
        var pos=url.indexOf('uri=');
        if(pos!=-1)
        {
            var pos2=url.indexOf('&',pos+4);
            if(pos2==-1)
            {
                var temp=url.substring(pos+4);
                temp=escape(temp);
                url=url.substring(0,pos+4)+temp;

            }
            else
            {
                var temp=url.substring(pos+4,pos2);
                temp=escape(temp);
                url=url.substring(0,pos+4)+temp+url.substring(pos2);

            }
        }

        return url;
    }
    function limitText(limitField, limitNum) {
        //alert(limitField.getValue(false));
        if (limitField.getValue(false).length > limitNum) {
            limitField.setValue(limitField.getValue(false).substring(0, limitNum));
        }
    }
    function addOption(olist, value, text) {
        if (value.length>0) {
            olist[olist.length] = new Option(text, value);
        }
    }

    function clearList(list) {
        for(x = list.length; x >= 0 ; x--) {
            list[x] = null;
        }
    }

    function clearSelected(list) {
        var i = 0;
        var newVals = [];
        for(x = 0; x < list.length; x++) {
            if (list[x].selected == false) {
                newVals[i++] = list[x].value;
            }
        }
        clearList(list);

        for(x = 0; x < i; x++) {
            addOption(list, newVals[x], newVals[x]);
        }
    }

    function addToList(olist, ibox) {
        addOption(olist, ibox.value, ibox.value);
        ibox.value="";
    }

    function setReferences(list, field) {
        var refs = "";
        for (x = 0; x < list.length; x++) {
            refs = refs + list[x].value + ",";
        }
        field.value = refs.substring(0,refs.length-1);
        field.form.submit();
    }
    -->
</script><%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            SemanticProperty forumCat_captcha = SWBForumCatResource.forumCat_captcha;
            boolean captcha = paramRequest.getResourceBase().getSemanticObject().getBooleanProperty(forumCat_captcha, true);
            SimpleDateFormat dateFormat;
            SimpleDateFormat iso8601dateFormat;
            DecimalFormat df = new java.text.DecimalFormat("#0.0#");
            DecimalFormat numerosformat = new java.text.DecimalFormat("###,###,##0");
            String lang = "es";
            Locale locale = new Locale(lang);
            dateFormat = new SimpleDateFormat("yyyy-MMM-dd", locale);
            String[] months =
            {
                "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
            };

            java.text.DateFormatSymbols fs = dateFormat.getDateFormatSymbols();
            fs.setShortMonths(months);

            dateFormat.setDateFormatSymbols(fs);
            String defaultFormat = "d 'de' MMMM 'del' yyyy 'a las' HH:mm";
            iso8601dateFormat = new SimpleDateFormat(defaultFormat, locale);

            User user = paramRequest.getUser();
            boolean isAdmin = false;
            Role role = user.getUserRepository().getRole("adminForum");
            if (role != null && user.hasRole(role))
            {
                isAdmin = true;
            }

            SimpleDateFormat datef = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
            DateFormatSymbols datesimbol = datef.getDateFormatSymbols();
            datesimbol.setAmPmStrings(new String[]
                    {
                        "a.m.", "p.m."
                    });
            datef.setDateFormatSymbols(datesimbol);
            WebPage wpage = paramRequest.getWebPage();
            Resource base = paramRequest.getResourceBase();
            SemanticObject semanticBase = base.getResourceData();
            SWBForumCatResource forum = new SWBForumCatResource(semanticBase);
            SWBResourceURL renderURL = paramRequest.getRenderUrl();
            SWBResourceURL pageURL = paramRequest.getRenderUrl();
            SWBResourceURL actionURL = paramRequest.getActionUrl();
            if ("deleteTema".equals(paramRequest.getAction()))
            {
%>
<jsp:include page="deleteTema.jsp" flush="true"/>
<%
                return;
            }
            if ("showAdd".equals(paramRequest.getAction()))
            {
%>
<jsp:include page="showAdd.jsp" flush="true"/>
<%
                return;
            }
            if ("procesaAdd".equals(paramRequest.getAction()))
            {
%>
<jsp:include page="procesaAdd.jsp" flush="true"/>
<%
                return;
            }
            String defaultbaseimg = SWBPortal.getWebWorkPath() + "/models/" + wpage.getWebSiteId() + "/jsp/SWBForumCatResource/";
            String baseimg = defaultbaseimg;
            String photo = defaultbaseimg + "/profilePlaceholder.jpg";
            // ruta para producción
            String otherURL = null;//"http://app.empleo.gob.mx/STPSEmpleoWebBack/imageAction.do?method=getPhoto";
            //String otherURL="http://qa.app.empleo.gob.mx/STPSEmpleoWebBack/imageAction.do?method=getPhoto";
            String action = paramRequest.getAction();

            if (request.getParameter("searchAct") != null && request.getParameter("searchAct").equals("showDetail"))
            {
                action = "showDetail";
            }


//System.out.println("\n\naction="+action);

            if (action != null && action.equals("add"))
            {
                SWBFormMgr mgr = new SWBFormMgr(Question.sclass, wpage.getWebSite().getSemanticObject(), null);
                mgr.setLang(user.getLanguage());
                mgr.setSubmitByAjax(false);
                mgr.setType(mgr.TYPE_DOJO);

                actionURL.setAction("addQuestion");
                mgr.setAction(actionURL.toString());

                String name = "Anónimo";
                if (user.getId() != null)
                {
                    name = user.getFullName();
                }

                if (request.getParameter("cat") == null || paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat")) == null)
                {
                    return;
                }
                WebPage cat = paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat"));
                String namecat = cat.getTitle();
                String fecha = datef.format(java.util.Calendar.getInstance().getTime());

                int total = 0;
                if (user.getId() != null)
                {
                    Iterator<Question> questions = Question.ClassMgr.listQuestionByWebpage(cat);
                    questions = SWBComparator.sortByCreated(questions, false);
                    while (questions.hasNext())
                    {
                        Question q = questions.next();
                        /*if (!q.isAnonymous() && q.getCreator() != null && q.getCreator().getId() != null && q.getCreator().getId().equals(user.getId()) && q.getQueStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                        if (!q.isAnonymous() && q.getCreator() != null && q.getCreator().getId() != null && q.getCreator().getId().equals(user.getId()))
                        {
                            total++;
                        }

                    }
                }
                String stotal = numerosformat.format(total);
%>


<script type="text/javascript">
    dojo.require("dijit.Editor");
    var editor1;
    dojo.addOnLoad(function(){
        var descField=dojo.byId("teditor");
        editor1=new dijit.Editor({id:'editor1',style:'{ background:#ffffe5; border:1px solid #ececec; }',plugins:['cut','copy','paste','|','bold','italic','underline','strikethrough'],height:'200px'},descField);
        editor1.onKeyDown=function()
        {
            limitText(editor1,2000);
        };
        editor1.onKeyPressed=function()
        {
            limitText(editor1,2000);
        };
        editor1.onKeyUp=function()
        {
            limitText(editor1,2000);
        };
        editor1.startup();
    });

    function validaforma2()
    {
        var content = editor1.getValue(false);

        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar un mensaje!');
            editor1.focus();
            return;
        }
        if(!confirm('¿La respuesta es correcta?'))
        {
            return;
        }
        document.getElementById('formaCaptura').elements['<%=Answer.forumCat_answer.getName()%>'].value=content;
        document.getElementById('formaCaptura').submit();
    }
    function validaforma()
    {
        var content = editor1.getValue(false);

        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar un mensaje!');
            editor1.focus();
            return;
        }

        var code=document.getElementById('formaCaptura');
        var codeValue=code.elements['code'].value;
        if(!codeValue || codeValue=='')
        {
            alert('¡Debe ingresar el texto de la imagen!');
            code.focus();
            return;
        }
        if(!confirm('¿El mensaje es correcto?'))
        {
            return;
        }


        document.getElementById('formaCaptura').elements['<%=Question.forumCat_question.getName()%>'].value=content;

        document.getElementById('formaCaptura').submit();

    }
</script>
<div id="foro">

    <h3>Tema: <strong><%=namecat%></strong></h3>
    <!-- valid -->
    <form id="formaCaptura" name="datosRegistro" action="<%=actionURL%>" method="post">
        <input type="hidden" name="cat" value="<%=request.getParameter("cat")%>">
        <input type="hidden" name="<%=Tagable.swb_tags.getName()%>" value=" ">
        <input type="hidden" name="<%=Question.forumCat_question.getName()%>" value="">
        <input type="hidden" name="categoryuri" value="<%=cat.getURI()%>">
        <input type="hidden" name="<%=Question.forumCat_questionReferences.getName()%>">
        <%= mgr.getFormHiddens()%>
        <table border="0" cellspacing="0" cellpadding="0" id="redaccion">
            <tr>
                <th><%=fecha%></th>
                <th>Mensaje</th>
            </tr>
            <tr>
                <td>
                    <div class="usuario">
                        <h4><%=name%></h4>
                        <p>
                            <%
                                            if (user.getPhoto() != null)
                                            {
                                                photo = baseimg + user.getPhoto();
                                            }
                                            else if (otherURL != null)
                                            {
                                                photo = otherURL + "&username=" + user.getLogin();
                                            }
                            %>
                            <%--<img src="<%=photo%>" width="90" height="90" alt="imagen del usuario" />--%><br />
                            <%
                                            if (user.getId() != null)
                                            {
                            %>
                            Mensajes en el tema <strong>[&nbsp; <%=stotal%>&nbsp;]</strong>
                            <%
                                            }
                            %>

                        </p>
                    </div></td>
                <td>

                    <div class="crear_carta">

                        <img src="/swbadmin/jsp/securecode.jsp" alt="" id="imgseccode" width="155" height="65" /><a href="javascript:changeSecureCodeImage('imgseccode');">Cambiar imagen</a>
                        <p><label for="cmnt_seccode">El texto de la imagen es: &nbsp;&nbsp;</label><input maxlength="4" size="4" id="code" type="text" name="code" value=""/></p>


                        <!-- <p class="maximo_caracteres"><b>Los mensajes y respuestas del foro deberán ser aprobados antes de ser publicados.</b></p> -->
                        <p class="maximo_caracteres">Máximo 2000 caracteres&nbsp;&nbsp;
                        </p>
                        <textarea name="teditor" id="teditor" cols="100" rows="2"></textarea>
                    </div>
                    <input type="button" onclick="javascript:validaforma();" class="boton" value="Publicar" />
                    <input type="button" class="boton" value="Regresar" onclick="javascript:history.go(-1);"/>
                </td>
            </tr>
        </table>
    </form>
</div>

<%
            }
            else if (action != null && action.equals("edit"))
            {
%>



<%
                if (request.getParameter("cat") != null)
                {
//System.out.println("cat="+request.getParameter("cat"));
                    String url = paramRequest.getWebPage().getUrl();
%>
<div class="foro_gral"> <!-- todo -->
    <p><strong><a href="<%=url%>">Página de inicio de los foros</a></strong></p>
    <%
                    }
                    int recPerPage = 5;
                    if (semanticBase.getIntProperty(SWBForumCatResource.forumCat_maxQuestions) != 0)
                    {
                        recPerPage = semanticBase.getIntProperty(SWBForumCatResource.forumCat_maxQuestions);
                    }
                    int nRec = 0;
                    int nPage;
                    try
                    {
                        nPage = Integer.parseInt(request.getParameter("page"));
                    }
                    catch (Exception ignored)
                    {
                        nPage = 1;
                    }
                    boolean paginate = false;

                    ArrayList<Question> questions = new ArrayList<Question>();




                    if (request.getParameter("cat") != null && paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat")) != null)
                    {

                        WebPage cat = paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat"));
                        String name = cat.getTitle();
                        String descriptioncat = cat.getDescription() != null ? cat.getDescription() : "";
    %>
    <h3>Tema: <strong><%=name%></strong></h3>
    <%
                            /*if (cat.getDescription() != null)
                            {*/
    %>
    <p><%=descriptioncat%></p>
    <%
                            /*}*/
//System.out.println("user.isSigned() || forum.isAcceptGuessComments()=" + (user.isSigned() || forum.isAcceptGuessComments()));
                            if (user.isSigned() || forum.isAcceptGuessComments())
                            {
                                renderURL.setAction("add");
                                renderURL.setParameter("cat", request.getParameter("cat"));

    %>


    <span><%--<img src="<%=defaultbaseimg%>icon_publicar_problema.png" alt="crear un mensaje" />--%></span><a class="liga_icon" href="<%=renderURL.toString(true)%>">Publicar un mensaje</a>
    <%


                        }

                        Iterator<Question> itQuestions_uo = Question.ClassMgr.listQuestionByWebpage(cat);
                        itQuestions_uo = SWBComparator.sortByCreated(itQuestions_uo, false);
                        while (itQuestions_uo.hasNext())
                        {
                            Question question = itQuestions_uo.next();
//System.out.println("question="+question.getId());
                            //if (question.getQueStatus() == SWBForumCatResource.STATUS_ACEPTED)
                            //{
                            questions.add(question);
                            //}
                        }

                    }





                    for (Question question : questions)
                    {

                        renderURL.setParameter("uri", question.getURI());
                        actionURL.setParameter("uri", question.getURI());
                        Answer favAnswer = null;
                        Answer comAnswer = null;
                        int nLike = 0;
                        int nUnlike = 0;
                        if (true)
                        {
                            paginate = true;
                            nRec++;
                            if ((nRec > (nPage - 1) * recPerPage) && (nRec <= (nPage) * recPerPage))
                            {

                                String creator = "Anónimo";
                                if (!question.isAnonymous())
                                {
                                    creator = question.getCreator().getFullName();
                                    if (question.getCreator().getPhoto() != null)
                                    {
                                        photo = SWBPortal.getWebWorkPath() + question.getCreator().getPhoto();
                                    }
                                }

                                Iterator<Answer> answers = question.listAnswerInvs();
                                int ansVotes = 0;
                                while (answers.hasNext())
                                {
                                    Answer answer = answers.next();

                                    /*if (answer.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)
                                    {*/

                                    if (answer.isBestAnswer())
                                    {
                                        favAnswer = answer;
                                    }

                                    Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(answer);
                                    while (itAnswerVote.hasNext())
                                    {
                                        AnswerVote answerVote = itAnswerVote.next();
                                        if (answerVote.isLikeAnswer() && !answerVote.isIrrelevantVote())
                                        {
                                            ansVotes++;
                                        }
                                    }

                                    if (ansVotes > nLike)
                                    {
                                        nLike = ansVotes;
                                        comAnswer = answer;
                                    }
                                    /*}*/
                                }

                                nLike = 0;
                                if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isQuestionVotable))
                                {
                                    Iterator<QuestionVote> itQuestionVote = QuestionVote.ClassMgr.listQuestionVoteByQuestionVote(question);
                                    while (itQuestionVote.hasNext())
                                    {
                                        QuestionVote questionVote = itQuestionVote.next();
                                        if (questionVote.isLikeVote())
                                        {
                                            nLike++;
                                        }
                                        else
                                        {
                                            nUnlike++;
                                        }
                                    }
                                }
                                renderURL.setAction("showDetail");
                                renderURL.setParameter("page", request.getParameter("page"));

                                String date = "";
                                if (question.getCreated() != null)
                                {
                                    date = getTimeAgo(question.getCreated(), user.getLanguage());
                                }
                                String msg = question.getQuestion();//clean(question.getQuestion());
%>

    <%
                                    msg = msg.replace("&lt;", "<");
                                    msg = msg.replace("&gt;", ">");
                                    msg = msg.replace("<em>", "<i>");
                                    msg = msg.replace("</em>", "</i>");
                                    msg = msg.replace("<strong>", "<b>");
                                    msg = msg.replace("</strong>", "</b>");
                                    /*if (msg.length() > 70)
                                    {
                                    msg = msg.substring(0, 70) + " ...";
                                    }*/

    %>
    <ul>
        <li>
            <div class="foto_foro_pregunta">
                <%
                                                if (question.getCreator().getPhoto() != null)
                                                {
                                                    photo = baseimg + question.getCreator().getPhoto();
                                                }
                                                else if (otherURL != null)
                                                {
                                                    photo = otherURL + "&username=" + question.getCreator().getLogin();
                                                }
                %>
                <%--<img alt="usuario"  width="40" height="40" src="<%=photo%>"/>--%></div>
            <span class="usuario"><%=creator%>.</span>
            <%=date%>&nbsp;&nbsp; <%--, <span class="vistas"><%=question.getViews()%> visitas.</span>--%>
            <%-- <a href="<%=renderURL.toString(true)%>" class="ligapregunta">Mensaje:</a>--%>


            <%
                                            if (user.isSigned() || semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_acceptGuessComments))
                                            {
                                                if (!question.isClosed())
                                                {
                                                    renderURL.setAction("answerQuestion");
                                                    renderURL.setParameter("org", "edit");
                                                    if (!isAdmin && user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                    {
                                                        int innapropiateCount = question.getQueInappropriate();
                                                        String queInappropriate = numerosformat.format(question.getQueInappropriate());
                                                        if (!question.isQueIsApropiate() && !question.getCreator().getURI().equals(user.getURI()))
                                                        {
                                                            SWBResourceURL markQuestionAsInnapropiate = paramRequest.getActionUrl();
                                                            markQuestionAsInnapropiate.setAction("markQuestionAsInnapropiate");
                                                            markQuestionAsInnapropiate.setParameter("org", "showDetail");
                                                            markQuestionAsInnapropiate.setParameter("cat", question.getWebpage().getId());
                                                            markQuestionAsInnapropiate.setParameter("uri", question.getURI());

                                                            if (innapropiateCount > forum.getMaxInnapropiateCount())
                                                            {
            %>&nbsp;&nbsp;&nbsp;<%=queInappropriate%> reportes de mensaje inapropiado&nbsp;<%
                                                                        }
                                                                        else
                                                                        {


            %><a href="<%=markQuestionAsInnapropiate.toString(true)%>">Reportar como inapropiado</a>&nbsp; Reportes: <%=queInappropriate%><%
                                                                        }

                                                                    }
                                                                    else
                                                                    {
            %>
            <%=queInappropriate%> Reportes como inapropiado&nbsp;
            <%
                                                                    }

            %>
            <%
                                                                    if (user.isSigned())
                                                                    {
            %>
            <br/><br/><a href="<%=renderURL.toString(true)%>">Responder</a>&nbsp;
            <%
                                                                    }
            %>


            <%
                                                                }

                                                            }
                                                            if (!question.isClosed() && user.isSigned() && question.getCreator() != null && user.getURI().equals(question.getCreator().getURI()))
                                                            {
                                                                renderURL.setAction("editQuestion");
                                                                renderURL.setParameter("org", "edit");
                                                                renderURL.setParameter("cat", question.getWebpage().getId());
                                                                renderURL.setParameter("cat", question.getWebpage().getId());
            %>
            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp
            <%
                                                            }
                                                            if (user.isSigned() && (isAdmin || ((question.getCreator() != null && user.getURI().equals(question.getCreator().getURI())))))
                                                            {
                                                                SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                                                actionURLClose.setAction("removeQuestion");
                                                                //actionURLClose.setParameter("org", "showDetail");
                                                                actionURLClose.setParameter("cat", question.getWebpage().getId());
                                                                actionURLClose.setParameter("uri", question.getEncodedURI());
                                                                String text = clean(question.getQuestion(), 35);
                                                                text = SWBUtils.TEXT.encodeBase64(text);
            %>
            <a href="javascript:deleteMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;
            <%
                                                            }
                                                            if (user.isSigned() && isAdmin)
                                                            {
                                                                SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                                                actionURLClose.setAction("RejectQuestion");
                                                                actionURLClose.setParameter("org", "showDetail");
                                                                actionURLClose.setParameter("cat", question.getWebpage().getId());
                                                                actionURLClose.setParameter("uri", question.getEncodedURI());
                                                                actionURLClose.setParameter("deleted", "true");

                                                                String text = clean(question.getQuestion(), 35);
                                                                text = SWBUtils.TEXT.encodeBase64(text);


            %>
            <%-- <a href="javascript:rejectMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp; --%>
            <%

                                                            }
                                                            if (!question.isClosed() && user.isSigned() && (isAdmin || (question.getCreator() != null && user.getURI().equals(question.getCreator().getURI()))))
                                                            {
                                                                SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                                                actionURLClose.setAction("closeQuestion");
                                                                actionURLClose.setParameter("org", "showDetail");
                                                                actionURLClose.setParameter("cat", question.getWebpage().getId());
                                                                actionURLClose.setParameter("uri", question.getEncodedURI());
                                                                String text = clean(question.getQuestion(), 35);
                                                                text = SWBUtils.TEXT.encodeBase64(text);
            %>
            <%-- <a href="javascript:closeMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Cerrar</a>&nbsp; --%>
            <%

                                                            }
                                                            if (question.isClosed() && user.isSigned() && (isAdmin || (question.getCreator() != null && user.getURI().equals(question.getCreator().getURI()))))
                                                            {
                                                                SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                                                actionURLClose.setAction("openQuestion");
                                                                actionURLClose.setParameter("org", "showDetail");
                                                                actionURLClose.setParameter("uri", question.getEncodedURI());
                                                                String text = clean(question.getQuestion(), 35);
                                                                text = SWBUtils.TEXT.encodeBase64(text);
            %>
            <a href="javascript:openMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Abrir de nuevo la pregunta</a>&nbsp;
            <%
                                                }

                                            }
                                            renderURL.setAction("answerQuestion");
                                            renderURL.setParameter("org", "edit");
                                            renderURL.setParameter("uri", question.getURI());
            %>
            <%
                                            if (user.isSigned())
                                            {
            %>
            &nbsp;<a href="<%=renderURL.toString(true)%>">Responder</a>&nbsp;&nbsp;
            <%
                                            }
            %>

            <%

                                            renderURL.setAction("showDetail");
                                            renderURL.setParameter("page", request.getParameter("page"));
                                            renderURL.setParameter("uri", question.getURI());
            %>
            <a href="<%=renderURL.toString(true)%>">Ver respuestas</a>
            <br/><p><%=msg%></p> <!-- 1 -->
            <%

            %>
        </li>
        <%
                                        boolean showQuestions = false;
                                        Iterator<Answer> itanswers = question.listAnswerInvs();
                                        while (itanswers.hasNext())
                                        {
                                            /*if (itanswers.next().getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)
                                            {*/
                                            showQuestions = true;
                                            break;
                                            /*}*/
                                        }
                                        if (showQuestions)
                                        {
        %>
        <li><ul>
                <%                                                    }
                %>


                <%
                                                if (favAnswer != null)
                                                {
                                                    String starimg = baseimg + "star_vacia.png";
                                                    String alt = "Vacía";
                                                    int points = 0;
                                                    creator = "Anónimo";

                                                    if (!favAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                    {
                                                        starimg = baseimg;
                                                        points = getUserPoints(favAnswer.getCreator(), wpage.getWebSite());
                                                        if (points <= 30)
                                                        {
                                                            starimg = baseimg + "star_vacia.png";
                                                            alt = "Vacía";
                                                        }
                                                        else if (points >= 31 && points <= 80)
                                                        {
                                                            starimg = baseimg + "star_plata.png";
                                                            alt = "Plata";
                                                        }
                                                        else if (points >= 81 && points <= 130)
                                                        {
                                                            starimg = baseimg + "star_oro.png";
                                                            alt = "Oro";
                                                        }
                                                        else if (points >= 131)
                                                        {
                                                            starimg = baseimg + "star_diamante.png";
                                                            alt = "Diamante";
                                                        }
                                                    }

                                                    photo = defaultbaseimg + "/profilePlaceholder.jpg";
                                                    if (!favAnswer.isAnonymous())
                                                    {
                                                        creator = favAnswer.getCreator().getFullName();
                                                        if (favAnswer.getCreator().getPhoto() != null)
                                                        {
                                                            photo = SWBPortal.getWebWorkPath() + favAnswer.getCreator().getPhoto();
                                                        }
                                                    }

                                                    if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                    {
                                                        Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(favAnswer);
                                                        while (itAnswerVote.hasNext())
                                                        {
                                                            AnswerVote answerVote = itAnswerVote.next();
                                                            if (answerVote.isLikeAnswer())
                                                            {
                                                                nLike++;
                                                            }
                                                            else if (!answerVote.isIrrelevantVote())
                                                            {
                                                                nUnlike++;
                                                            }
                                                        }
                                                    }
                %>
                <li class="titulo">Mi respuesta favorita</li>
                <li class="grupo_respuestas_gral">
                    <div class="respuestas_gral">
                        <%--<div class="puntos">

                        <img width="30" height="30" alt="<%=alt%>" title="<%=alt%> - <%=points%> puntos" src="<%=starimg%>" />
                        <%if (!favAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                            {%>
                        (<%=points%> puntos)
                        <%=countUserQuestions(favAnswer.getCreator(), wpage.getWebSite())%> preguntas
                        <%=countUserAnswers(favAnswer.getCreator(), wpage.getWebSite())%> respuestas
                        <%}%>
                    </div> --%>
                        <div class="foto">
                            <%
                                                                                String msgresp = clean(favAnswer.getAnswer());

                                                                                if (favAnswer.getCreator().getPhoto() != null)
                                                                                {
                                                                                    photo = baseimg + favAnswer.getCreator().getPhoto();
                                                                                }
                                                                                else if (otherURL != null)
                                                                                {
                                                                                    photo = otherURL + "&username=" + favAnswer.getCreator().getLogin();
                                                                                }
                            %>
                            <img alt="imagen usuario"  width="40" height="40" src="<%=photo%>"/>
                        </div>
                        <div class="respuesta_gral">
                            <span class="usuario"><%=creator%></span>
                            <%
                                                                                String daterespuesta = "";
                                                                                if (favAnswer.getCreated() != null)
                                                                                {
                                                                                    daterespuesta = getTimeAgo(favAnswer.getCreated(), user.getLanguage());
                                                                                }
                            %>
                            <%=daterespuesta%> <br/><br/>Re: <%=msgresp%><br/><br/>
                        </div>
                        <div class="herramientas_foro_gral">

                            <%
                                                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                                {
                                                                                    if (!favAnswer.isAnonymous() && !user.getURI().equals(favAnswer.getCreator().getURI()) && !favAnswer.userHasVoted(user))
                                                                                    {
                                                                                        actionURL.setParameter("uri", favAnswer.getURI());
                                                                                        actionURL.setAction("voteAnswer");
                                                                                        actionURL.setParameter("likeVote", "true");
                                                                                        actionURL.setParameter("org", "edit");
                                                                                        actionURL.setParameter("page", request.getParameter("page"));
                            %>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/></a>(<%=nLike%>)

                            <%actionURL.setParameter("likeVote", "false");%>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/></a>(<%=nUnlike%>)

                            <%}
                                                                                                                    else
                                                                                                                    {%>

                            <img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/>(<%=nLike%>)


                            <img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/>(<%=nUnlike%>)

                            <%
                                                                                    }
                                                                                }
                                                                                /*
                                                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markIrrelevantAnswers))
                                                                                {
                                                                                if (!favAnswer.isAnonymous() && !favAnswer.getCreator().getURI().equals(user.getURI()) && !favAnswer.userHasVoted(user))
                                                                                {
                                                                                actionURL = paramRequest.getActionUrl();
                                                                                actionURL.setParameter("uri", favAnswer.getURI());
                                                                                actionURL.setAction("voteAnswer");
                                                                                actionURL.setParameter("irrelevant", "true");
                                                                                actionURL.setParameter("org", "edit");
                                                                                actionURL.setParameter("page", request.getParameter("page"));*/
                            %>
                            <%--
                                                        <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png" /></a>(<%=favAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                /*}
                                                                                else
                                                                                {*/
                            %>
                            <%--
                                                        <img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/>(<%=favAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                /*}
                                                                                }*/

                                                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                                                {
                                                                                    if (!favAnswer.isAnonymous() && !favAnswer.isAnsIsAppropiate() && !favAnswer.getCreator().getURI().equals(user.getURI()))
                                                                                    {
                                                                                        actionURL.setAction("markAnswerAsInnapropiate");
                                                                                        actionURL.setParameter("uri", favAnswer.getURI());
                                                                                        actionURL.setParameter("org", "showDetail");
                                                                                        actionURL.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                                                                                        if (favAnswer.getAnsInappropriate() > forum.getMaxInnapropiateCount())
                                                                                        {
                            %>

                            <%=favAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            %>

                            <%
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                            %><a href="<%=actionURL.toString(true)%>">Reportar como inapropiado</a> Reportes: <%=favAnswer.getAnsInappropriate()%><br/><br/>
                            <%

                                                                                                                        }


                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                            %>

                            <%=favAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            %>

                            <%
                                                                                    }
                                                                                }
                                                                                if (!favAnswer.getAnsQuestion().isClosed() && user.isSigned() && favAnswer.getCreator() != null && user.getURI().equals(favAnswer.getCreator().getURI()))
                                                                                {
                                                                                    renderURL.setAction("editAnswer");
                                                                                    renderURL.setParameter("uri", favAnswer.getURI());
                                                                                    renderURL.setParameter("org", "edit");
                                                                                    renderURL.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                            %>
                            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;&nbsp;
                            <%
                                                                                }
                                                                                if (user.isSigned() && (isAdmin || favAnswer.getCreator() != null && user.getURI().equals(favAnswer.getCreator().getURI())))
                                                                                {
                                                                                    SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                                    actionURLRemove.setAction("removeAnswer");
                                                                                    actionURLRemove.setParameter("uri", favAnswer.getEncodedURI());
                                                                                    actionURLRemove.setParameter("org", "showDetail");
                                                                                    actionURLRemove.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                                                                                    String text = clean(favAnswer.getAnswer(), 35);
                                                                                    text = SWBUtils.TEXT.encodeBase64(text);
                            %>
                            <a href="javascript:deleteMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;&nbsp;
                            <%
                                                                                }
                                                                                if (user.isSigned() && isAdmin)
                                                                                {
                                                                                    SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                                    actionURLRemove.setAction("RejectAnswer");
                                                                                    actionURLRemove.setParameter("org", "showDetail");
                                                                                    actionURLRemove.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                                                                                    actionURLRemove.setParameter("deleted", "true");
                                                                                    actionURLRemove.setParameter("uri", favAnswer.getEncodedURI());
                                                                                    String text = clean(favAnswer.getAnswer(), 35);
                                                                                    text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <%-- <a href="javascript:rejectMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp;&nbsp; --%>
                            <%
                                                                                }
                            %>

                        </div>
                    </div>
                </li>
                <%
                                                }
                                                if (comAnswer != null)
                                                {
                                                    String starimg = baseimg + "star_vacia.png";
                                                    String alt = "Vacía";
                                                    int points = 0;
                                                    creator = "Anónimo";

                                                    if (!comAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                    {
                                                        starimg = baseimg;
                                                        points = getUserPoints(comAnswer.getCreator(), wpage.getWebSite());
                                                        if (points <= 30)
                                                        {
                                                            starimg = baseimg + "star_vacia.png";
                                                            alt = "Vacía";
                                                        }
                                                        else if (points >= 31 && points <= 80)
                                                        {
                                                            starimg = baseimg + "star_plata.png";
                                                            alt = "Plata";
                                                        }
                                                        else if (points >= 81 && points <= 130)
                                                        {
                                                            starimg = baseimg + "star_oro.png";
                                                            alt = "Oro";
                                                        }
                                                        else if (points >= 131)
                                                        {
                                                            starimg = baseimg + "star_diamante.png";
                                                            alt = "Diamante";
                                                        }
                                                    }

                                                    photo = defaultbaseimg + "/profilePlaceholder.jpg";
                                                    if (!comAnswer.isAnonymous())
                                                    {
                                                        creator = comAnswer.getCreator().getFullName();
                                                        if (comAnswer.getCreator().getPhoto() != null)
                                                        {
                                                            photo = SWBPortal.getWebWorkPath() + comAnswer.getCreator().getPhoto();
                                                        }
                                                    }

                                                    if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                    {
                                                        Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(comAnswer);
                                                        while (itAnswerVote.hasNext())
                                                        {
                                                            AnswerVote answerVote = itAnswerVote.next();
                                                            if (answerVote.isLikeAnswer())
                                                            {
                                                                nLike++;
                                                            }
                                                            else if (!answerVote.isIrrelevantVote())
                                                            {
                                                                nUnlike++;
                                                            }
                                                        }
                                                    }
                %>
                <li class="titulo">Respuesta favorita de la comunidad</li>
                <li class="grupo_respuestas_gral">
                    <div class="respuestas_gral">
                        <%--<div class="puntos">

                        <img width="30" height="30" alt="<%=alt%>" title="<%=alt%> - <%=points%> puntos" src="<%=starimg%>"/>
                        <%if (!comAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                            {%>
                        (<%=points%> puntos)
                        <%=countUserQuestions(comAnswer.getCreator(), wpage.getWebSite())%> preguntas
                        <%=countUserAnswers(comAnswer.getCreator(), wpage.getWebSite())%> respuestas
                        <%}%>

                    </div>--%>
                        <div class="foto">
                            <%
                                                                                if (comAnswer.getCreator().getPhoto() != null)
                                                                                {
                                                                                    photo = baseimg + comAnswer.getCreator().getPhoto();
                                                                                }
                                                                                else if (otherURL != null)
                                                                                {
                                                                                    photo = otherURL + "&username=" + comAnswer.getCreator().getLogin();
                                                                                }

                            %>
                            <img alt="imagen usuario"  width="40" height="40" src="<%=photo%>"/>
                        </div>
                        <div class="respuesta_gral">
                            <span class="usuario"><%=creator%></span>
                            <%
                                                                                String msgresp = clean(comAnswer.getAnswer());
                                                                                String daterespuesta = "";
                                                                                if (comAnswer.getCreated() != null)
                                                                                {
                                                                                    daterespuesta = getTimeAgo(comAnswer.getCreated(), user.getLanguage());
                                                                                }
                            %>
                            <%=daterespuesta%> <br/><br/>Re: <%=msgresp%><br/><br/>
                            <%
                                                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                                                {
                                                                                    if (!comAnswer.isAnonymous() && !comAnswer.isAnsIsAppropiate() && !comAnswer.getCreator().getURI().equals(user.getURI()))
                                                                                    {
                                                                                        actionURL.setAction("markAnswerAsInnapropiate");
                                                                                        actionURL.setParameter("uri", comAnswer.getURI());
                                                                                        actionURL.setParameter("org", "showDetail");
                                                                                        actionURL.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                                                                                        if (comAnswer.getAnsInappropriate() > forum.getMaxInnapropiateCount())
                                                                                        {
                            %><%=comAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                            %>  <a href="<%=actionURL.toString(true)%>">Reportar como inapropiado</a>&nbsp;Reportes: <%=comAnswer.getAnsInappropriate()%><br/><br/>
                            <%

                                                                                                                        }


                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                            %><%=comAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                    }
                                                                                }
                                                                                if (!comAnswer.getAnsQuestion().isClosed() && user.isSigned() && comAnswer.getCreator() != null && user.getURI().equals(comAnswer.getCreator().getURI()))
                                                                                {
                                                                                    renderURL.setAction("editAnswer");
                                                                                    renderURL.setParameter("uri", comAnswer.getURI());
                                                                                    renderURL.setParameter("org", "edit");
                                                                                    renderURL.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                            %>
                            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;&nbsp;
                            <%
                                                                                }
                                                                                if (user.isSigned() && (isAdmin || comAnswer.getCreator() != null && user.getURI().equals(comAnswer.getCreator().getURI())))
                                                                                {
                                                                                    SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                                    actionURLRemove.setAction("removeAnswer");
                                                                                    actionURLRemove.setParameter("uri", comAnswer.getEncodedURI());
                                                                                    //actionURLRemove.setParameter("org", "moderate");
                                                                                    actionURLRemove.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                                                                                    String text = clean(comAnswer.getAnswer(), 35);
                                                                                    text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <a href="javascript:deleteMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;&nbsp;
                            <%
                                                                                }
                                                                                if (user.isSigned() && isAdmin)
                                                                                {
                                                                                    SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                                    actionURLRemove.setAction("RejectAnswer");

                                                                                    actionURLRemove.setParameter("org", "showDetail");
                                                                                    actionURLRemove.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                                                                                    actionURLRemove.setParameter("deleted", "true");
                                                                                    actionURLRemove.setParameter("uri", comAnswer.getEncodedURI());
                                                                                    String text = clean(comAnswer.getAnswer(), 35);
                                                                                    text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <%--<a href="javascript:rejectMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp;&nbsp;--%>
                            <%
                                                                                }
                            %>
                        </div>
                        <div class="herramientas_foro_gral">

                            <%
                                                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                                {
                                                                                    if (!comAnswer.isAnonymous() && !user.getURI().equals(comAnswer.getCreator().getURI()) && !comAnswer.userHasVoted(user))
                                                                                    {
                                                                                        actionURL.setParameter("uri", comAnswer.getURI());
                                                                                        actionURL.setAction("voteAnswer");
                                                                                        actionURL.setParameter("likeVote", "true");
                                                                                        actionURL.setParameter("org", "edit");
                                                                                        actionURL.setParameter("page", request.getParameter("page"));
                            %>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/></a>(<%=nLike%>)

                            <%actionURL.setParameter("likeVote", "false");%>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/></a>(<%=nUnlike%>)

                            <%
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                            %>

                            <img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/>(<%=nLike%>)


                            <img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/>(<%=nUnlike%>)

                            <%
                                                                                    }
                                                                                }
                                                                                /*
                                                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markIrrelevantAnswers))
                                                                                {
                                                                                if (!comAnswer.isAnonymous() && !comAnswer.getCreator().getURI().equals(user.getURI()) && !comAnswer.userHasVoted(user))
                                                                                {
                                                                                actionURL = paramRequest.getActionUrl();
                                                                                actionURL.setParameter("uri", comAnswer.getURI());
                                                                                actionURL.setAction("voteAnswer");
                                                                                actionURL.setParameter("irrelevant", "true");
                                                                                actionURL.setParameter("org", "edit");
                                                                                actionURL.setParameter("page", request.getParameter("page"));*/
                            %>
                            <%--
                                                        <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/></a>(<%=comAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                /*}
                                                                                else
                                                                                {*/
                            %>
                            <%--
                                                        <img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/>(<%=comAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                /*}
                                                                                }*/
                            %>

                        </div>
                    </div>
                </li>
                <%
                                                }
                                                answers = SWBComparator.sortByCreated(question.listAnswerInvs(), false);
                                                ArrayList<Answer> answers_a = new ArrayList<Answer>();

                                                while (answers.hasNext())
                                                {
                                                    Answer a = answers.next();
                                                    if (!a.equals(favAnswer) && !a.equals(comAnswer))
                                                    {
                                                        /*if (a != null && a.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                                                        if (a != null)
                                                        {
                                                            answers_a.add(a);
                                                        }
                                                    }
                                                }

                                                answers = answers_a.iterator();
                                                int itotalanswers = 0;
                                                if (comAnswer != null)
                                                {
                                                    itotalanswers++;
                                                }
                                                if (answers.hasNext())
                                                {


                                                    while (answers.hasNext())
                                                    {
                                                        Answer answer = answers.next();
                                                        /*if (answer != null && answer.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                                                        if (answer != null)
                                                        {
                                                            itotalanswers++;

                                                        }

                                                    }
                                                }

                                                answers = answers_a.iterator();
                                                int ianswers = 0;
                                                if (answers.hasNext())
                                                {


                                                    while (answers.hasNext())
                                                    {
                                                        Answer answer = answers.next();
                                                        /*if (answer != null && answer.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                                                        if (answer != null)
                                                        {
                                                            ianswers++;
                                                            if (ianswers >= MAX_RESPUESTAS)
                                                            {
                                                                break;
                                                            }
                                                        }

                                                    }
                                                }
                                                answers = answers_a.iterator();
                                                if (answers.hasNext())
                                                {
                                                    String text = "Últimas ";
                                                    String textresp = "respuestas";
                                                    String textresp2 = "respuestas";
                                                    String numberResp = "" + ianswers;
                                                    if (answers_a.size() == 1)
                                                    {
                                                        text = "Última ";
                                                        textresp = "respuesta";
                                                        numberResp = "";
                                                    }
                                                    if (itotalanswers == 1)
                                                    {
                                                        textresp2 = "respuesta";
                                                    }


                %><li class="titulo"><%=text%> <%=numberResp%> <%=textresp%> de un total de <%=itotalanswers%> <%=textresp2%></li><%
                                                                    ianswers = 0;
                                                                    while (answers.hasNext())
                                                                    {
                                                                        Answer answer = answers.next();
                                                                        /*if (answer != null && answer.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                                                                        if (answer != null)
                                                                        {
                                                                            ianswers++;
                                                                            if (ianswers > MAX_RESPUESTAS)
                                                                            {
                                                                                break;
                                                                            }
                                                                            String starimg = baseimg + "star_vacia.png";
                                                                            String alt = "Vacía";
                                                                            int points = 0;
                                                                            creator = "Anónimo";

                                                                            if (!answer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                            {
                                                                                starimg = baseimg;
                                                                                points = getUserPoints(answer.getCreator(), wpage.getWebSite());
                                                                                if (points <= 30)
                                                                                {
                                                                                    starimg = baseimg + "star_vacia.png";
                                                                                    alt = "Vacía";
                                                                                }
                                                                                else if (points >= 31 && points <= 80)
                                                                                {
                                                                                    starimg = baseimg + "star_plata.png";
                                                                                    alt = "Plata";
                                                                                }
                                                                                else if (points >= 81 && points <= 130)
                                                                                {
                                                                                    starimg = baseimg + "star_oro.png";
                                                                                    alt = "Oro";
                                                                                }
                                                                                else if (points >= 131)
                                                                                {
                                                                                    starimg = baseimg + "star_diamante.png";
                                                                                    alt = "Diamante";
                                                                                }
                                                                            }

                                                                            photo = defaultbaseimg + "/profilePlaceholder.jpg";
                                                                            if (!answer.isAnonymous())
                                                                            {
                                                                                creator = answer.getCreator().getFullName();
                                                                                if (answer.getCreator().getPhoto() != null)
                                                                                {
                                                                                    photo = SWBPortal.getWebWorkPath() + answer.getCreator().getPhoto();
                                                                                }
                                                                            }
                                                                            renderURL.setParameter("uri", answer.getURI());
                                                                            actionURL.setParameter("uri", answer.getURI());
                                                                            nLike = 0;
                                                                            nUnlike = 0;
                                                                            if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                            {
                                                                                Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(answer);
                                                                                while (itAnswerVote.hasNext())
                                                                                {
                                                                                    AnswerVote answerVote = itAnswerVote.next();
                                                                                    if (answerVote.isLikeAnswer())
                                                                                    {
                                                                                        nLike++;
                                                                                    }
                                                                                    else if (!answerVote.isIrrelevantVote())
                                                                                    {
                                                                                        nUnlike++;
                                                                                    }
                                                                                }
                                                                            }
                %>
                <li class="grupo_respuestas_gral">
                    <div class="respuestas_gral">
                        <%--<div class="puntos">

                        <img width="30" height="30" alt="<%=alt%>" title="<%=alt%> - <%=points%> puntos" src="<%=starimg%>"/>
                        <%if (!answer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                                                {%>
                        (<%=points%> puntos)
                        <%=countUserQuestions(answer.getCreator(), wpage.getWebSite())%> preguntas
                        <%=countUserAnswers(answer.getCreator(), wpage.getWebSite())%> respuestas
                        <%}%>

                    </div>--%>
                        <div class="foto">
                            <%
                                                                                                            if (answer.getCreator().getPhoto() != null)
                                                                                                            {
                                                                                                                photo = baseimg + answer.getCreator().getPhoto();
                                                                                                            }
                                                                                                            else if (otherURL != null)
                                                                                                            {
                                                                                                                photo = otherURL + "&username=" + answer.getCreator().getLogin();
                                                                                                            }
                            %>
                            <img alt="imagen usuario"  width="40" height="40" src="<%=photo%>"/>
                        </div>
                        <div class="respuesta_gral">
                            <span><%=creator%></span>
                            <%
                                                                                                            String msgresp = clean(answer.getAnswer());
                                                                                                            String fecha = "";
                                                                                                            if (answer.getCreated() != null)
                                                                                                            {
                                                                                                                fecha = getTimeAgo(answer.getCreated(), user.getLanguage());
                                                                                                            }
                            %>
                            <%=fecha%>
                            <%
                                                                                                            if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                                                                            {
                                                                                                                if (!answer.isAnonymous() && !answer.isAnsIsAppropiate() && !answer.getCreator().getURI().equals(user.getURI()))
                                                                                                                {
                                                                                                                    actionURL.setAction("markAnswerAsInnapropiate");
                                                                                                                    actionURL.setParameter("uri", answer.getURI());
                                                                                                                    actionURL.setParameter("org", "showDetail");
                                                                                                                    actionURL.setParameter("cat", answer.getAnsQuestion().getWebpage().getId());
                                                                                                                    if (answer.getAnsInappropriate() > forum.getMaxInnapropiateCount())
                                                                                                                    {
                            %><%=answer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                            %>  <a href="<%=actionURL.toString(true)%>">Reportar como inapropiado</a>&nbsp; Reportes: <%=answer.getAnsInappropriate()%><br/><br/>
                            <%

                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                            %><%=answer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                                                }
                                                                                                            }


                                                                                                            if (!answer.getAnsQuestion().isClosed() && user.isSigned() && answer.getCreator() != null && user.getURI().equals(answer.getCreator().getURI()))
                                                                                                            {
                                                                                                                renderURL.setAction("editAnswer");
                                                                                                                renderURL.setParameter("uri", answer.getURI());
                                                                                                                renderURL.setParameter("org", "edit");
                                                                                                                renderURL.setParameter("cat", answer.getAnsQuestion().getWebpage().getId());
                            %>
                            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;&nbsp;
                            <%
                                                                                                            }
                                                                                                            if (user.isSigned() && question.getCreator() != null && question.getCreator().getURI().equals(user.getURI()))
                                                                                                            {

                                                                                                                if (!answer.isAnonymous() && !answer.getCreator().getURI().equals(user.getURI()) && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markBestAnswer))
                                                                                                                {
                                                                                                                    actionURL.setAction("bestAnswer");
                                                                                                                    actionURL.setParameter("org", "edit");
                            %><a href="<%=actionURL.toString(true)%>">Mejor respuesta</a>&nbsp;<%
                                                                                                                }
                                                                                                            }

                                                                                                            if (user.isSigned() && (isAdmin || (answer.getCreator() != null && user.getURI().equals(answer.getCreator().getURI()))))
                                                                                                            {
                                                                                                                SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                                                                actionURLRemove.setAction("removeAnswer");
                                                                                                                actionURLRemove.setParameter("uri", answer.getEncodedURI());
                                                                                                                actionURLRemove.setParameter("org", "showDetail");
                                                                                                                actionURLRemove.setParameter("cat", answer.getAnsQuestion().getWebpage().getId());
                                                                                                                text = clean(answer.getAnswer(), 35);
                                                                                                                text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <a href="javascript:deleteMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;&nbsp;
                            <%
                                                                                                            }
                                                                                                            if (user.isSigned() && isAdmin)
                                                                                                            {
                                                                                                                SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                                                                actionURLRemove.setAction("RejectAnswer");
                                                                                                                actionURLRemove.setParameter("uri", answer.getEncodedURI());
                                                                                                                actionURLRemove.setParameter("org", "showDetail");
                                                                                                                actionURLRemove.setParameter("cat", answer.getAnsQuestion().getWebpage().getId());
                                                                                                                actionURLRemove.setParameter("deleted", "true");
                                                                                                                text = clean(answer.getAnswer(), 35);
                            %>

                            <%-- <a href="javascript:rejectMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp;&nbsp; --%>
                            <%
                                                                                                            }
                            %>
                            <br/><br/>Re: <%=msgresp%>
                        </div>
                        <div class="herramientas_foro_gral">

                            <%
                                                                                                            if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                                                            {
                                                                                                                if (!answer.isAnonymous() && !user.getURI().equals(answer.getCreator().getURI()) && !answer.userHasVoted(user))
                                                                                                                {
                                                                                                                    actionURL.setParameter("uri", answer.getURI());
                                                                                                                    actionURL.setAction("voteAnswer");
                                                                                                                    actionURL.setParameter("likeVote", "true");
                                                                                                                    actionURL.setParameter("org", "edit");
                                                                                                                    actionURL.setParameter("page", request.getParameter("page"));
                            %>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/></a>(<%=nLike%>)

                            <%actionURL.setParameter("likeVote", "false");%>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/></a>(<%=nUnlike%>)

                            <%
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                            %>

                            <img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/>(<%=nLike%>)

                            <img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/>(<%=nUnlike%>)

                            <%
                                                                                                                }
                                                                                                            }
                                                                                                            /*if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markIrrelevantAnswers))
                                                                                                            {
                                                                                                            if (!answer.isAnonymous() && !answer.getCreator().getURI().equals(user.getURI()) && !answer.userHasVoted(user))
                                                                                                            {
                                                                                                            actionURL = paramRequest.getActionUrl();
                                                                                                            actionURL.setParameter("uri", answer.getURI());
                                                                                                            actionURL.setAction("voteAnswer");
                                                                                                            actionURL.setParameter("irrelevant", "true");
                                                                                                            actionURL.setParameter("org", "edit");
                                                                                                            actionURL.setParameter("page", request.getParameter("page"));*/
                            %>
                            <%--
                                                        <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/></a>(<%=answer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                                            /*}
                                                                                                            else
                                                                                                            {*/
                            %>
                            <%--
                                                        <img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/>(<%=answer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                                            /*}
                                                                                                            }*/
                            %>

                        </div>
                    </div>
                </li>
                <%
                                                        }
                                                    }
                                                }
                %>
                <%
                                                if (showQuestions)
                                                {
                %>
            </ul></li>
            <%                                                    }
            %>

        <%-- <li>
            <img width="730" height="11" alt="separacion" src="<%=defaultbaseimg%>separa_foro.png">
        </li> --%>
    </ul>
    <%
                            }
                        }
                    }
                    int npages = (int) (Math.ceil((double) nRec / (double) recPerPage) + 1);
                    if (npages > 21)
                    {
                        npages = 21;
                    }
                    if (paginate && npages > 2)
                    {

    %>
    <div id="paginacion">
        <span>P&aacute;ginas:</span>&nbsp;&nbsp;

        <%
                                for (int countPage = 1; countPage < npages; countPage++)
                                {
                                    pageURL.setParameter("page", "" + (countPage));
                                    pageURL.setParameter("cat", request.getParameter("cat"));
                                    if (countPage == nPage)
                                    {
        %>

        <%=countPage%>
        <%
                                            }
                                            else
                                            {
        %><a href="<%=pageURL.toString(true)%>"><%=countPage%></a>&nbsp;&nbsp;<%
                                    }
                                }

        %>

        <%
                                if (request.getParameter("cat") != null || request.getParameter("cat") != null)
                                {
        %>
    </div> <!-- todo -->
    <%                                                    }
    %>

    <%
                    }
    %></div><%
                }
                else if (action != null && action.equals("showDetail"))
                {
                    WebPage cat = null;
                    SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("uri"));
                    Object value = semObject.createGenericInstance();

                    if (value instanceof Answer)
                    {
                        Answer answer = (Answer) value;
                        value = answer.getAnsQuestion();
                        semObject = answer.getAnsQuestion().getSemanticObject();
                    }

                    String url = paramRequest.getWebPage().getUrl();
    %>
<div class="foro_gral">
    <p><strong><a href="<%=url%>">Página de inicio de los foros</a></strong></p>

    <%

                        Question question = (Question) value;
                        cat = question.getWebpage();
                        /*if (question.getQueStatus() == SWBForumCatResource.STATUS_ACEPTED)
                        {*/
                        long views = question.getViews();
                        question.setViews(views + 1);
                        int ansVotes = 0;
                        int nLike = 0;
                        int nUnlike = 0;
                        Answer favAnswer = null;
                        Answer comAnswer = null;
                        String creator = "Anónimo";
                        if (!question.isAnonymous())
                        {
                            creator = question.getCreator().getFullName();
                            if (question.getCreator().getPhoto() != null)
                            {
                                photo = SWBPortal.getWebWorkPath() + question.getCreator().getPhoto();
                            }
                        }

                        renderURL.setParameter("uri", question.getURI());
                        actionURL.setParameter("uri", question.getURI());

                        Iterator<Answer> answers = question.listAnswerInvs();
                        while (answers.hasNext())
                        {
                            Answer answer = answers.next();
                            /*if (answer.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)
                            {*/
                            if (answer.isBestAnswer())
                            {
                                favAnswer = answer;
                            }

                            Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(answer);
                            while (itAnswerVote.hasNext())
                            {
                                AnswerVote answerVote = itAnswerVote.next();
                                if (!answerVote.isIrrelevantVote() && answerVote.isLikeAnswer())
                                {
                                    ansVotes++;
                                }
                            }

                            if (ansVotes > nLike)
                            {
                                nLike = ansVotes;
                                comAnswer = answer;
                            }
                            /*}*/
                        }

                        nLike = 0;
                        if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isQuestionVotable))
                        {
                            Iterator<QuestionVote> itQuestionVote = QuestionVote.ClassMgr.listQuestionVoteByQuestionVote(question);
                            while (itQuestionVote.hasNext())
                            {
                                QuestionVote questionVote = itQuestionVote.next();
                                if (questionVote.isLikeVote())
                                {
                                    nLike++;
                                }
                                else
                                {
                                    nUnlike++;
                                }
                            }
                        }
                        if (user.isSigned() || semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_acceptGuessComments))
                        {
                            renderURL.setAction("add");
                        }
    %>
    <ul>
        <li>
            <div class="foto_foro_pregunta">
                <%
                                    if (question.getCreator().getPhoto() != null)
                                    {
                                        photo = baseimg + question.getCreator().getPhoto();
                                    }
                                    else if (otherURL != null)
                                    {
                                        photo = otherURL + "&username=" + question.getCreator().getLogin();
                                    }
                %>
                <%--<img alt="imagen usuario" width="40" height="40" src="<%=photo%>"/>--%></div>
            <span class="usuario"><%=creator%>.</span>
            <%
                                String date = "";
                                if (question.getCreated() != null)
                                {
                                    date = getTimeAgo(question.getCreated(), user.getLanguage());
                                }
                                String mensajerespuesta = question.getQuestion();
                                mensajerespuesta = mensajerespuesta.replace("&lt;", "<");
                                mensajerespuesta = mensajerespuesta.replace("&gt;", ">");
                                mensajerespuesta = mensajerespuesta.replace("<em>", "<i>");
                                mensajerespuesta = mensajerespuesta.replace("</em>", "</i>");
                                mensajerespuesta = mensajerespuesta.replace("<strong>", "<b>");
                                mensajerespuesta = mensajerespuesta.replace("</strong>", "</b>");
            %>
            <%=date%>&nbsp;&nbsp;
            <%--, <span class="vistas"><%=question.getViews()%> visitas.</span>--%>


            <%
                                if (!isAdmin && user.isSigned() || semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_acceptGuessComments))
                                {
                                    if (user.isSigned() && !question.isClosed())
                                    {
                                        renderURL.setAction("answerQuestion");
                                        renderURL.setParameter("org", "showDetail");
            %><a href="<%=renderURL.toString(true)%>">Responder</a>&nbsp;<%
                                                }
                                                if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                {

                                                    int innapropiateCount = question.getQueInappropriate();
                                                    String queInappropriate = numerosformat.format(question.getQueInappropriate());
                                                    if (innapropiateCount > forum.getMaxInnapropiateCount())
                                                    {
            %>&nbsp;&nbsp;&nbsp;<%=queInappropriate%> reportes de mensaje inapropiado&nbsp;<%
                                                                }
                                                                else
                                                                {

                                                                    SWBResourceURL markQuestionAsInnapropiate = paramRequest.getRenderUrl();
                                                                    markQuestionAsInnapropiate.setAction("markQuestionAsInnapropiate");
                                                                    markQuestionAsInnapropiate.setParameter("uri", question.getURI());
                                                                    markQuestionAsInnapropiate.setParameter("org", "showDetail");
            %><a href="<%=markQuestionAsInnapropiate.toString(true)%>">Reportar como inapropiado</a>&nbsp;Reportes: <%=queInappropriate%><%
                                                    }

                                                }
                                                if (!question.isClosed() && !question.isAnonymous() && user.isSigned() && user.getURI().equals(question.getCreator().getURI()))
                                                {
                                                    renderURL.setAction("editQuestion");
                                                    renderURL.setParameter("org", "edit");
                                                    renderURL.setParameter("cat", question.getWebpage().getId());
            %><a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;<%
                                    }
                                }
                                if (user.isSigned() && (isAdmin || ((question.getCreator() != null && user.getURI().equals(question.getCreator().getURI())))))
                                {
                                    SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                    actionURLClose.setAction("removeQuestion");
                                    //actionURLClose.setParameter("org", "showDetail");
                                    actionURLClose.setParameter("uri", question.getEncodedURI());
                                    String text = clean(question.getQuestion(), 35);
                                    text = SWBUtils.TEXT.encodeBase64(text);
            %>

            <a href="javascript:deleteMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;&nbsp;
            <%
                                }
                                if (user.isSigned() && isAdmin)
                                {
                                    SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                    actionURLClose.setAction("RejectQuestion");
                                    actionURLClose.setParameter("org", "showDetail");
                                    actionURLClose.setParameter("uri", question.getEncodedURI());
                                    actionURLClose.setParameter("deleted", "true");
                                    String text = clean(question.getQuestion(), 35);
                                    text = SWBUtils.TEXT.encodeBase64(text);
            %>

            <%-- <a href="javascript:rejectMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp;&nbsp; --%>
            <%
                                }
                                if (!question.isClosed() && user.isSigned() && (isAdmin || (question.getCreator() != null && user.getURI().equals(question.getCreator().getURI()))))
                                {
                                    SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                    actionURLClose.setAction("closeQuestion");
                                    actionURLClose.setParameter("org", "showDetail");
                                    actionURLClose.setParameter("uri", question.getEncodedURI());

                                    String text = clean(question.getQuestion(), 35);
                                    text = SWBUtils.TEXT.encodeBase64(text);
            %>


            <%--<a href="javascript:closeMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Cerrar</a>&nbsp;--%>

            <%
                                }
                                if (question.isClosed() && user.isSigned() && (isAdmin || (question.getCreator() != null && user.getURI().equals(question.getCreator().getURI()))))
                                {
                                    SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                    actionURLClose.setAction("openQuestion");
                                    actionURLClose.setParameter("org", "showDetail");
                                    actionURLClose.setParameter("uri", question.getEncodedURI());
                                    String text = clean(question.getQuestion(), 35);
                                    text = SWBUtils.TEXT.encodeBase64(text);
            %>
            <a href="javascript:openMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Abrir de nuevo la pregunta</a>&nbsp;
            <%
                                }
            %>
            <br/><br/><%=mensajerespuesta%>
        </li>
        <%

                            boolean showQuestions = false;
                            Iterator<Answer> itanswers = question.listAnswerInvs();
                            while (itanswers.hasNext())
                            {
                                /*if (itanswers.next().getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)
                                {*/
                                showQuestions = true;
                                break;
                                /*}*/
                            }
                            if (showQuestions)
                            {
        %>
        <li><ul>
                <%                                                    }
                %>

                <%
                                    if (favAnswer != null)
                                    {
                                        String starimg = baseimg + "star_vacia.png";
                                        String alt = "Vacía";
                                        int points = 0;
                                        creator = "Anónimo";

                                        if (!favAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                        {
                                            starimg = baseimg;
                                            points = getUserPoints(favAnswer.getCreator(), wpage.getWebSite());
                                            if (points <= 30)
                                            {
                                                starimg = baseimg + "star_vacia.png";
                                                alt = "Vacía";
                                            }
                                            else if (points >= 31 && points <= 80)
                                            {
                                                starimg = baseimg + "star_plata.png";
                                                alt = "Plata";
                                            }
                                            else if (points >= 81 && points <= 130)
                                            {
                                                starimg = baseimg + "star_oro.png";
                                                alt = "Oro";
                                            }
                                            else if (points >= 131)
                                            {
                                                starimg = baseimg + "star_diamante.png";
                                                alt = "Diamante";
                                            }
                                        }

                                        photo = defaultbaseimg + "/profilePlaceholder.jpg";
                                        if (!favAnswer.isAnonymous())
                                        {
                                            creator = favAnswer.getCreator().getFullName();
                                            if (favAnswer.getCreator().getPhoto() != null)
                                            {
                                                photo = SWBPortal.getWebWorkPath() + favAnswer.getCreator().getPhoto();
                                            }
                                        }
                                        nLike = 0;
                                        nUnlike = 0;
                                        if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                        {
                                            Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(favAnswer);
                                            while (itAnswerVote.hasNext())
                                            {
                                                AnswerVote answerVote = itAnswerVote.next();
                                                if (answerVote.isLikeAnswer())
                                                {
                                                    nLike++;
                                                }
                                                else if (!answerVote.isIrrelevantVote())
                                                {
                                                    nUnlike++;
                                                }
                                            }
                                        }
                %>
                <li class="titulo">Mi respuesta favorita</li>
                <li class="grupo_respuestas_gral">
                    <div class="respuestas_gral">
                        <%--<div class="puntos">

                        <img width="30" height="30" alt="<%=alt%>" title="<%=alt%> - <%=points%> puntos" src="<%=starimg%>"/>
                        <%if (!favAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                    {%>
                        (<%=points%> puntos)
                        <%=countUserQuestions(favAnswer.getCreator(), wpage.getWebSite())%> preguntas
                        <%=countUserAnswers(favAnswer.getCreator(), wpage.getWebSite())%> respuestas
                        <%}%>

                    </div>--%>
                        <div class="foto">
                            <%
                                                                    if (favAnswer.getCreator().getPhoto() != null)
                                                                    {
                                                                        photo = baseimg + favAnswer.getCreator().getPhoto();
                                                                    }
                                                                    else if (otherURL != null)
                                                                    {
                                                                        photo = otherURL + "&username=" + favAnswer.getCreator().getLogin();
                                                                    }
                            %>
                            <img alt="imagen usuario" width="40" height="40" src="<%=photo%>"/>
                        </div>
                        <div class="respuesta_gral">
                            <span class="usuario"><%=creator%></span>
                            <%
                                                                    String msgresp = clean(favAnswer.getAnswer());
                                                                    String fecha = "";
                                                                    if (favAnswer.getCreated() != null)
                                                                    {
                                                                        fecha = getTimeAgo(favAnswer.getCreated(), user.getLanguage());
                                                                    }
                            %>
                            <%=fecha%>&nbsp;&nbsp;
                            <%
                                                                    if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                                    {
                                                                        if (favAnswer != null && !favAnswer.isAnonymous() && !favAnswer.isAnsIsAppropiate() && !favAnswer.getCreator().getURI().equals(user.getURI()))
                                                                        {
                                                                            actionURL.setAction("markAnswerAsInnapropiate");
                                                                            actionURL.setParameter("uri", favAnswer.getURI());
                                                                            actionURL.setParameter("org", "showDetail");
                                                                            actionURL.setParameter("cat", cat.getId());
                                                                            if (favAnswer != null && favAnswer.getAnsInappropriate() > forum.getMaxInnapropiateCount())
                                                                            {
                            %><%=favAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                                        }
                                                                                                        else
                                                                                                        {
                            %> <a href="<%=actionURL.toString(true)%>">Reportar como inapropiado</a>&nbsp; Reportes: <%=favAnswer.getAnsInappropriate()%><br/><br/>
                            <%

                                                                                                        }


                                                                                                    }
                                                                                                    else
                                                                                                    {
                            %><%=favAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                        }
                                                                    }
                                                                    if (!favAnswer.getAnsQuestion().isClosed() && user.isSigned() && favAnswer.getCreator() != null && user.getURI().equals(favAnswer.getCreator().getURI()))
                                                                    {
                                                                        renderURL.setAction("editAnswer");
                                                                        renderURL.setParameter("org", "edit");
                                                                        renderURL.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                            %>
                            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;&nbsp;
                            <%
                                                                    }
                                                                    if (user.isSigned() && (isAdmin || (favAnswer.getCreator() != null && user.getURI().equals(favAnswer.getCreator().getURI()))))
                                                                    {
                                                                        SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                        actionURLRemove.setAction("removeAnswer");
                                                                        actionURLRemove.setParameter("uri", favAnswer.getEncodedURI());
                                                                        actionURLRemove.setParameter("org", "showDetail");
                                                                        actionURLRemove.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                                                                        String text = clean(favAnswer.getAnswer(), 35);
                                                                        text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <a href="javascript:deleteMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;&nbsp;
                            <%
                                                                    }
                                                                    if (user.isSigned() && isAdmin)
                                                                    {
                                                                        SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                        actionURLRemove.setAction("RejectAnswer");
                                                                        actionURLRemove.setParameter("uri", favAnswer.getEncodedURI());
                                                                        actionURLRemove.setParameter("org", "showDetail");
                                                                        actionURLRemove.setParameter("cat", favAnswer.getAnsQuestion().getWebpage().getId());
                                                                        actionURLRemove.setParameter("deleted", "true");
                                                                        String text = clean(favAnswer.getAnswer(), 35);
                                                                        text = SWBUtils.TEXT.encodeBase64(text);
                            %>
                            <%-- <a href="javascript:rejectMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp; --%>
                            <%
                                                                    }
                            %>
                            <br/><br/>Re: <%=msgresp%>
                        </div>
                        <div class="herramientas_foro_gral">
                            <%
                                                                    if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                    {
                                                                        if (favAnswer != null && !favAnswer.isAnonymous() && user.getURI() != null && favAnswer.getCreator() != null && !user.getURI().equals(favAnswer.getCreator().getURI()) && !favAnswer.userHasVoted(user))
                                                                        {
                                                                            actionURL.setParameter("uri", favAnswer.getURI());
                                                                            actionURL.setAction("voteAnswer");
                                                                            actionURL.setParameter("likeVote", "true");
                                                                            actionURL.setParameter("org", "showDetail");
                            %>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/></a>(<%=nLike%>)

                            <%actionURL.setParameter("likeVote", "false");%>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/></a>(<%=nUnlike%>)

                            <%
                                                                                                    }
                                                                                                    else
                                                                                                    {
                            %>

                            <img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/>(<%=nLike%>)

                            <img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/>(<%=nUnlike%>)

                            <%
                                                                        }
                                                                    }
                                                                    /*if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markIrrelevantAnswers))
                                                                    {
                                                                    if (!favAnswer.isAnonymous() && !favAnswer.getCreator().getURI().equals(user.getURI()) && !favAnswer.userHasVoted(user))
                                                                    {
                                                                    actionURL = paramRequest.getActionUrl();
                                                                    actionURL.setParameter("uri", favAnswer.getURI());
                                                                    actionURL.setAction("voteAnswer");
                                                                    actionURL.setParameter("irrelevant", "true");
                                                                    actionURL.setParameter("org", "edit");
                                                                    actionURL.setParameter("page", request.getParameter("page"));*/
                            %>
                            <%--
                                                        <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/></a>(<%=favAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                    /*}
                                                                    else
                                                                    {*/
                            %>
                            <%--
                                                        <img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/>(<%=favAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                    /*}
                                                                    }*/

                            %>

                        </div>
                    </div>
                </li>
                <%


                                    }
                                    if (comAnswer != null)
                                    {
                                        String starimg = baseimg + "star_vacia.png";
                                        String alt = "Vacía";
                                        int points = 0;
                                        creator = "Anónimo";

                                        if (!comAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                        {
                                            starimg = baseimg;
                                            points = getUserPoints(comAnswer.getCreator(), wpage.getWebSite());
                                            if (points <= 30)
                                            {
                                                starimg = baseimg + "star_vacia.png";
                                                alt = "Vacía";
                                            }
                                            else if (points >= 31 && points <= 80)
                                            {
                                                starimg = baseimg + "star_plata.png";
                                                alt = "Plata";
                                            }
                                            else if (points >= 81 && points <= 130)
                                            {
                                                starimg = baseimg + "star_oro.png";
                                                alt = "Oro";
                                            }
                                            else if (points >= 131)
                                            {
                                                starimg = baseimg + "star_diamante.png";
                                                alt = "Diamante";
                                            }
                                        }

                                        photo = defaultbaseimg + "/profilePlaceholder.jpg";
                                        if (!comAnswer.isAnonymous())
                                        {
                                            creator = comAnswer.getCreator().getFullName();
                                            if (comAnswer.getCreator().getPhoto() != null)
                                            {
                                                photo = SWBPortal.getWebWorkPath() + comAnswer.getCreator().getPhoto();
                                            }
                                        }

                                        nLike = 0;
                                        nUnlike = 0;
                                        if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                        {
                                            Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(comAnswer);
                                            while (itAnswerVote.hasNext())
                                            {
                                                AnswerVote answerVote = itAnswerVote.next();
                                                if (answerVote.isLikeAnswer())
                                                {
                                                    nLike++;
                                                }
                                                else if (!answerVote.isIrrelevantVote())
                                                {
                                                    nUnlike++;
                                                }
                                            }
                                        }
                %>
                <li class="titulo">Respuesta favorita de la comunidad</li>
                <li class="grupo_respuestas_gral">
                    <div class="respuestas_gral">
                        <%--<div class="puntos">

                        <img width="30" height="30" alt="<%=alt%>" title="<%=alt%> - <%=points%> puntos" src="<%=starimg%>"/>
                        <%if (!comAnswer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                    {%>
                        (<%=points%> puntos)
                        <%=countUserQuestions(comAnswer.getCreator(), wpage.getWebSite())%> preguntas
                        <%=countUserAnswers(comAnswer.getCreator(), wpage.getWebSite())%> respuestas
                        <%}%>
                    </div>--%>
                        <div class="foto">
                            <%
                                                                    if (comAnswer.getCreator().getPhoto() != null)
                                                                    {
                                                                        photo = baseimg + comAnswer.getCreator().getPhoto();
                                                                    }
                                                                    else if (otherURL != null)
                                                                    {
                                                                        photo = otherURL + "&username=" + comAnswer.getCreator().getLogin();
                                                                    }
                            %>
                            <img alt="imagen usuario"  width="40" height="40" src="<%=photo%>"/>
                        </div>
                        <div class="respuesta_gral">
                            <span><%=creator%></span>

                            <%
                                                                    String msgresp = clean(comAnswer.getAnswer());
                                                                    String fecha = "";
                                                                    if (comAnswer.getCreated() != null)
                                                                    {
                                                                        fecha = getTimeAgo(comAnswer.getCreated(), user.getLanguage());
                                                                    }
                            %>
                            <%=fecha%>&nbsp;&nbsp;
                            <%
                                                                    if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                                    {
                                                                        if (!comAnswer.isAnonymous() && !comAnswer.isAnsIsAppropiate() && !comAnswer.getCreator().getURI().equals(user.getURI()))
                                                                        {
                                                                            actionURL.setAction("markAnswerAsInnapropiate");
                                                                            actionURL.setParameter("org", "showDetail");
                                                                            actionURL.setParameter("uri", comAnswer.getURI());
                                                                            actionURL.setParameter("cat", cat.getId());
                                                                            if (comAnswer != null && comAnswer.getAnsInappropriate() > forum.getMaxInnapropiateCount())
                                                                            {


                            %><br/><%=comAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            String queInappropriate = numerosformat.format(comAnswer.getAnsInappropriate());
                            %>  <br/><a href="<%=actionURL.toString(true)%>">Reportar como inapropiado</a>&nbsp; Reportes: <%=queInappropriate%><br/><br/>
                            <%

                                                                                                        }


                                                                                                    }
                                                                                                    else if (comAnswer != null)
                                                                                                    {
                            %><br/><%=comAnswer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                        }
                                                                    }
                                                                    if (!comAnswer.getAnsQuestion().isClosed() && user.isSigned() && comAnswer.getCreator() != null && user.getURI().equals(comAnswer.getCreator().getURI()))
                                                                    {
                                                                        renderURL.setAction("editAnswer");
                                                                        renderURL.setParameter("org", "edit");
                                                                        renderURL.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                            %>
                            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;&nbsp;
                            <%
                                                                    }
                                                                    if (user.isSigned() && (isAdmin || (comAnswer.getCreator() != null && user.getURI().equals(comAnswer.getCreator().getURI()))))
                                                                    {
                                                                        SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                        actionURLRemove.setAction("removeAnswer");
                                                                        actionURLRemove.setParameter("uri", comAnswer.getEncodedURI());
                                                                        actionURLRemove.setParameter("org", "showDetail");
                                                                        actionURLRemove.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                                                                        String text = clean(comAnswer.getAnswer(), 35);
                                                                        text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <a href="javascript:deleteMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Eliminar</a>>&nbsp;&nbsp;
                            <%
                                                                    }
                                                                    if (user.isSigned() && isAdmin)
                                                                    {
                                                                        SWBResourceURL actionURLRemove = paramRequest.getActionUrl();
                                                                        actionURLRemove.setAction("RejectAnswer");
                                                                        actionURLRemove.setParameter("uri", comAnswer.getEncodedURI());
                                                                        actionURLRemove.setParameter("org", "edit");
                                                                        actionURLRemove.setParameter("cat", comAnswer.getAnsQuestion().getWebpage().getId());
                                                                        actionURLRemove.setParameter("deleted", "true");
                                                                        String text = clean(comAnswer.getAnswer(), 35);
                                                                        text = SWBUtils.TEXT.encodeBase64(text);
                            %>
                            <%-- <a href="javascript:rejectMsg('<%=actionURLRemove.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp; --%>
                            <%
                                                                    }
                            %>
                            <br/><br/>Re: <%=msgresp%>
                        </div>
                        <div class="herramientas_foro_gral">

                            <%
                                                                    if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                    {
                                                                        if (!comAnswer.isAnonymous() && !user.getURI().equals(comAnswer.getCreator().getURI()) && !comAnswer.userHasVoted(user))
                                                                        {
                                                                            actionURL.setParameter("uri", comAnswer.getURI());
                                                                            actionURL.setAction("voteAnswer");
                                                                            actionURL.setParameter("likeVote", "true");
                                                                            actionURL.setParameter("org", "showDetail");
                            %>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/></a>(<%=nLike%>)

                            <%actionURL.setParameter("likeVote", "false");%>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/></a>(<%=nUnlike%>)

                            <%
                                                                                                    }
                                                                                                    else
                                                                                                    {
                            %>

                            <img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/>(<%=nLike%>)

                            <img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/>(<%=nUnlike%>)

                            <%
                                                                        }
                                                                    }
                                                                    /*if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markIrrelevantAnswers))
                                                                    {
                                                                    if (!comAnswer.isAnonymous() && !comAnswer.getCreator().getURI().equals(user.getURI()) && !comAnswer.userHasVoted(user))
                                                                    {
                                                                    actionURL = paramRequest.getActionUrl();
                                                                    actionURL.setParameter("uri", comAnswer.getURI());
                                                                    actionURL.setAction("voteAnswer");
                                                                    actionURL.setParameter("irrelevant", "true");
                                                                    actionURL.setParameter("org", "edit");
                                                                    actionURL.setParameter("page", request.getParameter("page"));*/
                            %>
                            <%--
                                                        <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/></a>(<%=comAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                    /*}
                                                                    else
                                                                    {*/
                            %>
                            <%--
                                                        <img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/>(<%=comAnswer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                    /*}
                                                                    }*/
                            %>

                        </div>
                    </div>
                </li>
                <%
                                    }

                                    answers = SWBComparator.sortByCreated(question.listAnswerInvs(), false);
                                    ArrayList<Answer> answers_a = new ArrayList<Answer>();
                                    while (answers.hasNext())
                                    {
                                        Answer a = answers.next();
                                        if (!a.equals(favAnswer) && !a.equals(comAnswer))
                                        {
                                            /*if (a != null && a.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)
                                            {*/
                                            answers_a.add(a);
                                            /*}*/
                                        }
                                    }

                                    answers = answers_a.iterator();
                                    if (answers.hasNext())
                                    {
                %><li class="titulo">Respuestas</li><%
                                                        while (answers.hasNext())
                                                        {
                                                            Answer answer = answers.next();
                                                            /*if (answer.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)
                                                            {*/
                                                            String atach = "";
                                                            Iterator<String> itt = answer.listAttachementses();
                                                            while (itt.hasNext())
                                                            {
                                                                atach += itt.next();
                                                            }
                                                            String starimg = baseimg + "star_vacia.png";
                                                            String alt = "Vacía";
                                                            int points = 0;
                                                            creator = "Anónimo";

                                                            if (!answer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                            {
                                                                starimg = baseimg;
                                                                points = getUserPoints(answer.getCreator(), wpage.getWebSite());
                                                                if (points <= 30)
                                                                {
                                                                    starimg = baseimg + "star_vacia.png";
                                                                    alt = "Vacía";
                                                                }
                                                                else if (points >= 31 && points <= 80)
                                                                {
                                                                    starimg = baseimg + "star_plata.png";
                                                                    alt = "Plata";
                                                                }
                                                                else if (points >= 81 && points <= 130)
                                                                {
                                                                    starimg = baseimg + "star_oro.png";
                                                                    alt = "Oro";
                                                                }
                                                                else if (points >= 131)
                                                                {
                                                                    starimg = baseimg + "star_diamante.png";
                                                                    alt = "Diamante";
                                                                }
                                                            }

                                                            photo = defaultbaseimg + "/profilePlaceholder.jpg";
                                                            if (!answer.isAnonymous())
                                                            {
                                                                creator = answer.getCreator().getFullName();
                                                                if (answer.getCreator().getPhoto() != null)
                                                                {
                                                                    photo = SWBPortal.getWebWorkPath() + answer.getCreator().getPhoto();
                                                                }
                                                            }
                                                            renderURL.setParameter("uri", answer.getURI());
                                                            actionURL.setParameter("uri", answer.getURI());
                                                            nLike = 0;
                                                            nUnlike = 0;
                                                            if (semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                            {
                                                                Iterator<AnswerVote> itAnswerVote = AnswerVote.ClassMgr.listAnswerVoteByAnswerVote(answer);
                                                                while (itAnswerVote.hasNext())
                                                                {
                                                                    AnswerVote answerVote = itAnswerVote.next();
                                                                    if (answerVote.isLikeAnswer())
                                                                    {
                                                                        nLike++;
                                                                    }
                                                                    else if (!answerVote.isIrrelevantVote())
                                                                    {
                                                                        nUnlike++;
                                                                    }
                                                                }
                                                            }
                %>
                <li class="grupo_respuestas_gral">
                    <div class="respuestas_gral">
                        <%--<div class="puntos">

                        <img width="30" height="30" alt="<%=alt%>" title="<%=alt%> - <%=points%> puntos" src="<%=starimg%>"/>
                        <%if (!answer.isAnonymous() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_useScoreSystem))
                                                                                        {%>
                        (<%=points%> puntos)
                        <%=countUserQuestions(answer.getCreator(), wpage.getWebSite())%> preguntas
                        <%=countUserAnswers(answer.getCreator(), wpage.getWebSite())%> respuestas
                        <%}%>

                    </div>--%>
                        <div class="foto">
                            <%
                                                                                        if (answer.getCreator().getPhoto() != null)
                                                                                        {
                                                                                            photo = baseimg + answer.getCreator().getPhoto();
                                                                                        }
                                                                                        else if (otherURL != null)
                                                                                        {
                                                                                            photo = otherURL + "&username=" + answer.getCreator().getLogin();
                                                                                        }
                            %>
                            <img alt="imagen usuario"  width="40" height="40" src="<%=photo%>"/>
                        </div>
                        <div class="respuesta_gral">
                            <span class="usuario"><%=creator%></span>
                            <%
                                                                                        String msgresp = clean(answer.getAnswer());
                                                                                        String fecha = "";
                                                                                        if (answer.getCreated() != null)
                                                                                        {
                                                                                            fecha = getTimeAgo(answer.getCreated(), user.getLanguage());
                                                                                        }
                            %>
                            <%=fecha%>&nbsp;&nbsp;
                            <%
                                                                                        if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markInnapropiateAnswers))
                                                                                        {
                                                                                            if (!answer.isAnonymous() && !answer.isAnsIsAppropiate() && !answer.getCreator().getURI().equals(user.getURI()))
                                                                                            {
                                                                                                actionURL.setAction("markAnswerAsInnapropiate");
                                                                                                actionURL.setParameter("org", "showDetail");
                                                                                                actionURL.setParameter("uri", answer.getURI());
                                                                                                actionURL.setParameter("cat", cat.getId());
                                                                                                if (answer != null && answer.getAnsInappropriate() > forum.getMaxInnapropiateCount())
                                                                                                {

                            %><%=answer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                String queInappropriate = numerosformat.format(answer.getAnsInappropriate());
                            %>  <a href="<%=actionURL.toString(true)%>">Reportar como inapropiado</a>&nbsp;Reportes: <%=queInappropriate%><br/><br/>
                            <%

                                                                                                                            }


                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                            %><%=answer.getAnsInappropriate()%> reportes de mensaje inapropiado<br/><br/>
                            <%
                                                                                            }
                                                                                        }
                                                                                        if (!question.isClosed() && user.isSigned() && question.getCreator() != null && user.getURI().equals(answer.getCreator().getURI()))
                                                                                        {
                                                                                            renderURL.setAction("editAnswer");
                                                                                            renderURL.setParameter("org", "edit");
                                                                                            renderURL.setParameter("cat", question.getWebpage().getId());
                            %>
                            <a href="<%=renderURL.toString(true)%>">Editar</a>&nbsp;&nbsp;
                            <%
                                                                                        }
                                                                                        if (user.isSigned() && (isAdmin || ((answer.getCreator() != null && user.getURI().equals(answer.getCreator().getURI())))))
                                                                                        {
                                                                                            SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                                                                            actionURLClose.setAction("removeAnswer");
                                                                                            actionURLClose.setParameter("org", "showDetail");
                                                                                            actionURLClose.setParameter("uri", question.getEncodedURI());
                                                                                            String text = clean(answer.getAnswer(), 35);
                                                                                            text = SWBUtils.TEXT.encodeBase64(text);
                            %>

                            <a href="javascript:deleteMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Eliminar</a>&nbsp;&nbsp;
                            <%
                                                                                        }
                                                                                        if (user.isSigned() && question.getCreator().getURI().equals(user.getURI()))
                                                                                        {
                                                                                            if (!answer.isAnonymous() && !answer.getCreator().getURI().equals(user.getURI()) && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markBestAnswer))
                                                                                            {
                                                                                                actionURL.setAction("bestAnswer");
                                                                                                actionURL.setParameter("org", "showDetail");
                            %><a href="<%=actionURL.toString(true)%>">Mejor respuesta</a>&nbsp;<%
                                                                                            }
                                                                                        }
                                                                                        if (user.isSigned() && isAdmin)
                                                                                        {
                                                                                            SWBResourceURL actionURLClose = paramRequest.getActionUrl();
                                                                                            actionURLClose.setAction("RejectAnswer");
                                                                                            actionURLClose.setParameter("org", "showDetail");
                                                                                            actionURLClose.setParameter("uri", answer.getEncodedURI());
                                                                                            actionURLClose.setParameter("deleted", "true");
                                                                                            String text = clean(answer.getAnswer(), 35);
                                                                                            text = SWBUtils.TEXT.encodeBase64(text);
                            %>
                            <%-- <a href="javascript:rejectMsg('<%=actionURLClose.toString(true)%>','<%=text%>')">Dar de baja</a>&nbsp;--%>
                            <%
                                                                                        }

                            %>
                            <br/><br/>Re: <%=msgresp%>
                        </div>
                        <div class="herramientas_foro_gral">

                            <%
                                                                                        if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_isAnswerVotable))
                                                                                        {
                                                                                            if (!answer.isAnonymous() && !user.getURI().equals(answer.getCreator().getURI()) && !answer.userHasVoted(user))
                                                                                            {
                                                                                                actionURL.setParameter("uri", answer.getURI());
                                                                                                actionURL.setAction("voteAnswer");
                                                                                                actionURL.setParameter("likeVote", "true");
                                                                                                actionURL.setParameter("org", "showDetail");
                            %>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/></a>(<%=nLike%>)

                            <%actionURL.setParameter("likeVote", "false");%>

                            <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/></a>(<%=nUnlike%>)

                            <%
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                            %>

                            <img width="18" height="18" alt="Me gusta" src="<%=defaultbaseimg%>icon_me_gusta.png"/>(<%=nLike%>)

                            <img width="18" height="18" alt="No me gusta" src="<%=defaultbaseimg%>icon_no_gusta.png"/>(<%=nUnlike%>)

                            <%
                                                                                            }
                                                                                        }

                                                                                        /*if (user.isSigned() && semanticBase.getBooleanProperty(SWBForumCatResource.forumCat_markIrrelevantAnswers))
                                                                                        {
                                                                                        if (!answer.isAnonymous() && !answer.getCreator().getURI().equals(user.getURI()) && !answer.userHasVoted(user))
                                                                                        {
                                                                                        actionURL = paramRequest.getActionUrl();
                                                                                        actionURL.setParameter("uri", answer.getURI());
                                                                                        actionURL.setAction("voteAnswer");
                                                                                        actionURL.setParameter("irrelevant", "true");
                                                                                        actionURL.setParameter("org", "edit");
                                                                                        actionURL.setParameter("page", request.getParameter("page"));*/
                            %>
                            <%--
                                                        <a href="<%=actionURL.toString(true)%>"><img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/></a>(<%=answer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                        /*}
                                                                                        else
                                                                                        {*/
                            %>
                            <%--
                                                        <img width="18" height="18" alt="¿Eso qué?" src="<%=defaultbaseimg%>icon_eso_que.png"/>(<%=answer.getAnsIrrelevant()%>) ¿Esto qu&eacute;?
                            --%>
                            <%
                                                                                        /*}
                                                                                        }*/

                            %>

                        </div>
                    </div>
                </li>
                <%



                                            /*}*/
                                        }
                                    }
                                    renderURL = paramRequest.getRenderUrl().setParameter("page", request.getParameter("page"));
                %>
                <%

                                    if (showQuestions)
                                    {
                %>
            </ul></li>
            <%                                                            }
            %>

        <%-- <img width="100%" height="11" alt="separacion" src="<%=defaultbaseimg%>separa_foro.png"> --%>

        <%
                            String urlback = paramRequest.getWebPage().getUrl();
                            if (request.getParameter("cat") != null)
                            {
                                urlback += "?cat=" + request.getParameter("cat");
                            }
                            else
                            {
                                urlback += "?cat=" + question.getWebpage().getId();
                            }

        %>
        <input type="button" class="boton" value="Regresar" onclick="document.location='<%=urlback%>'"/>
    </ul>
    <%
                        /*}*/
    %>
</div><%
            }
            else if (action != null && action.equals("editQuestion"))
            {
                SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("uri"));
                Question q = (Question) semObject.createGenericInstance();
                SWBFormMgr mgr = new SWBFormMgr(semObject, null, SWBFormMgr.MODE_EDIT);
                mgr.setLang(user.getLanguage());
                mgr.setFilterRequired(false);
                mgr.setType(mgr.TYPE_XHTML);
                actionURL.setAction("editQuestion");
                actionURL.setParameter("org", request.getParameter("org"));
                mgr.addHiddenParameter("uri", semObject.getURI());
                SemanticClass semClass = Question.sclass;
                String fecha = datef.format(java.util.Calendar.getInstance().getTime());
                if (request.getParameter("cat") == null || paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat")) == null)
                {
                    return;
                }
                WebPage cat = paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat"));
                String name = "Anónimo";
                if (user.getId() != null)
                {
                    name = user.getFullName();
                }

                String content = q.getQuestion();
                content = content.replace("&lt;", "<");
                content = content.replace("&gt;", ">");
                content = content.replace("<em>", "<i>");
                content = content.replace("</em>", "</i>");
                content = content.replace("<strong>", "<b>");
                content = content.replace("</strong>", "</b>");

                //content = checkHTML(content);
                int total = 0;
                if (user.getId() != null)
                {
                    Iterator<Question> questions = Question.ClassMgr.listQuestionByWebpage(cat);
                    questions = SWBComparator.sortByCreated(questions, false);
                    while (questions.hasNext())
                    {
                        Question question = questions.next();
                        /*if (!question.isAnonymous() && question.getCreator() != null && question.getCreator().getId() != null && question.getCreator().getId().equals(user.getId()) && question.getQueStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                        if (!question.isAnonymous() && question.getCreator() != null && question.getCreator().getId() != null && question.getCreator().getId().equals(user.getId()))
                        {
                            total++;
                        }

                    }
                }
                String stotal = numerosformat.format(total);
%>

<script type="text/javascript">
    dojo.require("dijit.Editor");
    var editor1;
    dojo.addOnLoad(function(){
        var descField=dojo.byId("teditor");
        editor1=new dijit.Editor({id:'editor1',style:'{ background:#ffffe5; border:1px solid #ececec; }',id:'editorw',plugins:['cut','copy','paste','|','bold','italic','underline','strikethrough'],height:'200px'},descField);
        editor1.onKeyDown=function()
        {
            limitText(editor1,2000);
        };
        editor1.onKeyPressed=function()
        {
            limitText(editor1,2000);
        };
        editor1.onKeyUp=function()
        {
            limitText(editor1,2000);
        };
        editor1.startup();
    });
    function validaforma2()
    {
        var content = editor1.getValue(false);
        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar un mensaje!');
            editor1.focus();
            return;
        }
        if(!confirm('¿La respuesta es correcta?'))
        {
            return;
        }
        document.getElementById('formaCaptura').elements['<%=Answer.forumCat_answer.getName()%>'].value=content;
        document.getElementById('formaCaptura').submit();
    }
    function validaforma()
    {
        var content = editor1.getValue(false);

        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar un mensaje!');
            editor1.focus();
            return;
        }

        var code=document.getElementById('formaCaptura');
        var codeValue=code.elements['code'].value;
        if(!codeValue || codeValue=='')
        {
            alert('¡Debe ingresar el texto de la imagen!');
            code.focus();
            return;
        }
        if(!confirm('¿El mensaje es correcto?'))
        {
            return;
        }


        document.getElementById('formaCaptura').elements['<%=Question.forumCat_question.getName()%>'].value=content;

        document.getElementById('formaCaptura').submit();

    }
</script>
<div id="foro">
    <!-- valid -->
    <form id="formaCaptura" name="datosRegistro" action="<%=actionURL%>" method="post">
        <input type="hidden" name="cat" value="<%=request.getParameter("cat")%>">
        <input type="hidden" name="<%=Question.forumCat_question.getName()%>" value="">
        <input type="hidden" name="categoryuri" value="<%=cat.getURI()%>">
        <input type="hidden" name="<%=Question.forumCat_questionReferences.getName()%>">
        <%= mgr.getFormHiddens()%>
        <table border="0" cellspacing="0" cellpadding="0" id="redaccion">
            <tr>
                <th><%=fecha%></th>
                <th>Mensaje</th>
            </tr>

            <tr>
                <td>
                    <div class="usuario">
                        <h4><%=name%></h4>
                        <p>
                            <%
                                            if (user.getPhoto() != null)
                                            {
                                                photo = user.getPhoto();
                                            }
                                            else if (otherURL != null)
                                            {
                                                photo = otherURL + "&username=" + user.getLogin();
                                            }
                            %>
                            <%--<img src="<%=photo%>" width="90" height="90" alt="imagen del usuario" />--%><br />
                            <%
                                            if (user.getId() != null)
                                            {
                            %>
                            <strong>Mensajes en este tema:</strong> <%=stotal%>
                            <%
                                            }
                            %>
                        </p>
                    </div>
                </td>
                <td>

                    <div class="crear_carta">

                        <img src="/swbadmin/jsp/securecode.jsp" alt="" id="imgseccode" width="155" height="65" /><a href="javascript:changeSecureCodeImage('imgseccode');">Cambiar imagen</a>
                        <p><label for="cmnt_seccode">El texto de la imagen es:&nbsp;&nbsp;</label><input maxlength="4" type="text" size="4" id="code" name="code" value=""/></p>


                        <!--<p class="maximo_caracteres"><b>Los mensajes y respuestas del foro deberán ser aprobados antes de ser publicados.</b></p>-->
                        <p class="maximo_caracteres">Máximo 2000 caracteres&nbsp;&nbsp;</p>
                        <textarea name="teditor" id="teditor" cols="100" rows="2"><%=content%></textarea>
                    </div>
                    <input type="button" onclick="javascript:validaforma();" class="boton" value="Modificar mensaje" />
                    <input type="button" class="boton" value="Regresar" onclick="javascript:history.go(-1);"/>
                </td>
            </tr>
        </table>
    </form>
</div>
<%
            }
            else if (action != null && action.equals("answerQuestion"))
            {
                SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("uri"));
                SWBFormMgr mgr = new SWBFormMgr(Answer.sclass, wpage.getWebSite().getSemanticObject(), null);
                mgr.setLang(user.getLanguage());
                mgr.setSubmitByAjax(false);
                Question q = (Question) semObject.createGenericInstance();
                mgr.setType(mgr.TYPE_DOJO);
                actionURL.setAction("answerQuestion");
                actionURL.setParameter("uri", semObject.getURI());
                actionURL.setParameter("org", request.getParameter("org"));
                mgr.setAction(actionURL.toString());
                mgr.addButton(SWBFormButton.newSaveButton());
                mgr.addButton(SWBFormButton.newCancelButton());
                SemanticClass semClass = Answer.sclass;
                String questionString = q.getQuestion();
                WebPage cat = q.getWebpage();
                String namecat = cat.getTitle();
                String fecha = datef.format(java.util.Calendar.getInstance().getTime());
                String name = "Anónimo";
                if (user.getId() != null)
                {
                    name = user.getFullName();
                }
                int total = 0;
                if (user.getId() != null)
                {
                    Iterator<Question> questions = Question.ClassMgr.listQuestionByWebpage(cat);
                    while (questions.hasNext())
                    {
                        Question question = questions.next();
                        if (!question.isAnonymous() && question.getCreator() != null && question.getCreator().getId() != null && question.getCreator().getId().equals(user.getId()))
                        {
                            total++;
                        }

                    }
                }
                java.text.DecimalFormat numberformat = new java.text.DecimalFormat("###,###,###");
                String stotal = numberformat.format(total);
%>

<script type="text/javascript">
    dojo.require("dijit.Editor");
    var editor1;
    dojo.addOnLoad(function(){
        var descField=dojo.byId("teditor");
        editor1=new dijit.Editor({id:'editor1',style:'{ background:#ffffe5; border:1px solid #ececec; }',id:'editorw',plugins:['cut','copy','paste','|','bold','italic','underline','strikethrough'],height:'200px'},descField);
        editor1.onKeyDown=function()
        {
            limitText(editor1,2000);
        };
        editor1.onKeyPressed=function()
        {
            limitText(editor1,2000);
        };
        editor1.onKeyUp=function()
        {
            limitText(editor1,2000);
        };
        editor1.startup();
    });
    function validaforma2()
    {
        var content = editor1.getValue(false);
        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar un mensaje!');
            editor1.focus();
            return;
        }
        var code=document.getElementById('formaCaptura');
        var codeValue=code.elements['code'].value;
        if(!codeValue || codeValue=='')
        {
            alert('¡Debe ingresar el texto de la imagen!');
            code.focus();
            return;
        }
        if(!confirm('¿La respuesta es correcta?'))
        {
            return;
        }

        document.getElementById('formaCaptura').elements['<%=Answer.forumCat_answer.getName()%>'].value=content;
        document.getElementById('formaCaptura').submit();
    }
    function validaforma()
    {
        var content = editor1.getValue(false);

        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar un mensaje!');
            editor1.focus();
            return;
        }

        if(!confirm('¿El mensaje es correcto?'))
        {
            return;
        }

        document.getElementById('formaCaptura').elements['<%=Question.forumCat_question.getName()%>'].value=content;

        document.getElementById('formaCaptura').submit();

    }
</script>
<div id="foro">

    <h3>Tema: <strong><%=namecat%></strong></h3>
    <form id="formaCaptura" name="datosRegistro" action="<%=actionURL%>" method="post">
        <input type="hidden" name="cat" value="<%=request.getParameter("cat")%>">
        <input type="hidden" name="<%=Answer.forumCat_answer.getName()%>" value="">
        <input type="hidden" name="<%=Answer.forumCat_references.getName()%>">
        <%= mgr.getFormHiddens()%>
        <table border="0" cellspacing="0" cellpadding="0" id="redaccion">
            <tr>
                <th><%=fecha%></th>
                <th>Mensaje</th>
            </tr>

            <tr>
                <td>
                    <div class="usuario">
                        <h4><%=name%></h4>
                        <p>
                            <%
                                            if (user.getPhoto() != null)
                                            {
                                                photo = baseimg + user.getPhoto();
                                            }
                                            else if (otherURL != null)
                                            {
                                                photo = otherURL + "&username=" + user.getLogin();
                                            }
                            %>
                            <%--<img src="<%=photo%>" width="90" height="90" alt="imagen del usuario" />--%><br />
                            <%
                                            if (user.getId() != null)
                                            {
                            %>
                            <strong>Mensajes en este tema:</strong> <%=stotal%>
                            <%
                                            }
                            %>

                        </p>
                    </div></td>
                <td>
                    <h2>Mensaje original: <%=clean(questionString, 35)%></h2><br/>

                    <div class="crear_carta">
                        <img src="/swbadmin/jsp/securecode.jsp" alt="" id="imgseccode" width="155" height="65" /><a href="javascript:changeSecureCodeImage('imgseccode');">Cambiar imagen</a>
                        <p><label for="cmnt_seccode">El texto de la imagen es:&nbsp;&nbsp;</label><input maxlength="4" type="text" size="4" id="code" name="code" value=""/></p>
                        <!--<p class="maximo_caracteres"><b>Los mensajes y respuestas del foro deberán ser aprobados antes de ser publicados.</b></p>-->
                        <p class="maximo_caracteres">Máximo 2000 caracteres&nbsp;&nbsp;
                        </p>
                        <textarea name="teditor" id="teditor" cols="100" rows="2"></textarea>
                    </div>
                    <input type="button" onClick="javascript:validaforma2();" class="boton" value="Publicar" />
                    <input type="button" class="boton" value="Regresar" onclick="javascript:history.go(-1);"/><br/>
                </td>
            </tr>
        </table>
    </form>

</div>
<%
            }
            else if (action != null && action.equals("editAnswer"))
            {
                if (request.getParameter("cat") == null || paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat")) == null)
                {
                    return;
                }
                WebPage cat = paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat"));
                SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("uri"));
                Answer answer = new Answer(semObject);
                SWBFormMgr mgr = new SWBFormMgr(semObject, null, SWBFormMgr.MODE_EDIT);
                mgr.setLang(user.getLanguage());
                mgr.setFilterRequired(false);
                mgr.setType(mgr.TYPE_DOJO);
                actionURL.setAction("editAnswer");
                actionURL.setParameter("uri", semObject.getURI());
                actionURL.setParameter("org", request.getParameter("org"));
                mgr.setAction(actionURL.toString());
                mgr.addButton(SWBFormButton.newSaveButton());
                mgr.addButton(SWBFormButton.newCancelButton());
                String fecha = datef.format(java.util.Calendar.getInstance().getTime());
                String name = "Anónimo";
                if (user.getId() != null)
                {
                    name = user.getFullName();
                }
                int total = 0;
                if (user.getId() != null)
                {
                    Iterator<Question> questions = Question.ClassMgr.listQuestionByWebpage(cat);
                    questions = SWBComparator.sortByCreated(questions, false);
                    while (questions.hasNext())
                    {
                        Question q = questions.next();
                        /*if (!q.isAnonymous() && q.getCreator() != null && q.getCreator().getId() != null && q.getCreator().getId().equals(user.getId()) && q.getQueStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                        if (!q.isAnonymous() && q.getCreator() != null && q.getCreator().getId() != null && q.getCreator().getId().equals(user.getId()))
                        {
                            total++;
                        }

                    }
                }
                String stotal = numerosformat.format(total);
                Question q = answer.getAnsQuestion();
                String content = answer.getAnswer();
                //String questionString = checkHTML(q.getQuestion());
                String questionString = q.getQuestion();
%>
<div id="foro">
    <script type="text/javascript">
        dojo.require("dijit.Editor");
        var editor1;
        dojo.addOnLoad(function(){
            var descField=dojo.byId("teditor");
            editor1=new dijit.Editor({id:'editor1',style:'{ background:#ffffe5; border:1px solid #ececec; }',id:'editorw',plugins:['cut','copy','paste','|','bold','italic','underline','strikethrough'],height:'200px'},descField);
            editor1.onKeyDown=function()
            {
                limitText(editor1,2000);
            };
            editor1.onKeyPressed=function()
            {
                limitText(editor1,2000);
            };
            editor1.onKeyUp=function()
            {
                limitText(editor1,2000);
            };
            editor1.startup();
        });
        function validaforma2()
        {
            var content = editor1.getValue(false);
            if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
            {
                alert('¡Debe ingresar un mensaje!');
                editor1.focus();
                return;
            }
            var code=document.getElementById('formaCaptura');
            var codeValue=code.elements['code'].value;
            if(!codeValue || codeValue=='')
            {
                alert('¡Debe ingresar el texto de la imagen!');
                code.focus();
                return;
            }
            if(!confirm('¿La respuesta es correcta?'))
            {
                return;
            }
            document.getElementById('formaCaptura').elements['<%=Answer.forumCat_answer.getName()%>'].value=content;
            document.getElementById('formaCaptura').submit();
        }
        function validaforma()
        {
            var content = editor1.getValue(false);

            if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
            {
                alert('¡Debe ingresar un mensaje!');
                editor1.focus();
                return;
            }
            if(!confirm('¿El mensaje es correcto?'))
            {
                return;
            }

            document.getElementById('formaCaptura').elements['<%=Question.forumCat_question.getName()%>'].value=content;

            document.getElementById('formaCaptura').submit();

        }
    </script>
    <!-- <h1>Editar respuesta</h1> -->
    <form id="formaCaptura" name="datosRegistro" action="<%=actionURL%>" method="post">
        <input type="hidden" name="cat" value="<%=request.getParameter("cat")%>">
        <input type="hidden" name="<%=Answer.forumCat_answer.getName()%>" value="">
        <input type="hidden" name="<%=Answer.forumCat_references.getName()%>">
        <input type="hidden" name="cat" value="<%=request.getParameter("cat")%>">
        <%= mgr.getFormHiddens()%>
        <table border="0" cellspacing="0" cellpadding="0" id="redaccion">
            <tr>
                <th><%=fecha%></th>
                <th>Mensaje</th>
            </tr>

            <tr>
                <td>
                    <div class="usuario">
                        <h4><%=name%></h4>
                        <p>
                            <%
                                            if (user.getPhoto() != null)
                                            {
                                                photo = baseimg + user.getPhoto();
                                            }
                                            else if (otherURL != null)
                                            {
                                                photo = otherURL + "&username=" + user.getLogin();
                                            }
                            %>
                            <img src="<%=photo%>" width="90" height="90" alt="imagen del usuario" /><br />
                            <%
                                            if (user.getId() != null)
                                            {
                            %>
                            <strong>Mensajes en este tema:</strong> <%=stotal%>
                            <%
                                            }
                            %>

                        </p>
                    </div></td>
                <td>
                    <h2>Mensaje original: <%=clean(questionString, 35)%></h2><br/>
                    <div class="crear_carta">
                        <img src="/swbadmin/jsp/securecode.jsp" alt="" id="imgseccode" width="155" height="65" /><a href="javascript:changeSecureCodeImage('imgseccode');">Cambiar imagen</a>
                        <p><label for="cmnt_seccode">El texto de la imagen es:&nbsp;&nbsp;</label><input maxlength="4" type="text" size="4" id="code" name="code" value=""/></p>
                        <!--<p class="maximo_caracteres"><b>Los mensajes y respuestas del foro deberán ser aprobados antes de ser publicados.</b></p>-->
                        <p class="maximo_caracteres">Máximo 2000 caracteres&nbsp;&nbsp;
                        </p>
                        <textarea id="teditor" cols="100" rows="2"><%=content%></textarea>
                    </div>
                    <input type="button" onClick="javascript:validaforma2();" class="boton" value="Modificar mensaje" />
                    <input type="button" class="boton" value="Regresar" onclick="javascript:history.go(-1);"/><br/>
                </td>
            </tr>
        </table>
    </form>
</div>
<%
            }
            else if (action != null && action.equals("moderate"))
            {
                boolean notEmpty = false;
                boolean quesHeader = false;
                if (isAdmin)
                {

                    String url = paramRequest.getWebPage().getUrl();
%>
<p><strong><a href="<%=url%>">Página de inicio de los foros</a></strong></p>
<%
%>
<ul class="sfcQuestList">
    <%
                        if (request.getParameter("cat") == null || paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat")) == null)
                        {
                            return;
                        }
                        int i = 0;
                        WebPage cat = paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat"));
                        ArrayList<Question> questions = new ArrayList<Question>();
                        Iterator itQuestions = Question.ClassMgr.listQuestionByWebpage(cat);
                        while (itQuestions.hasNext())
                        {
                            Question question = (Question) itQuestions.next();
                            if (question.getQuestion() == null || question.getQuestion().trim().length() == 0)
                            {
                                question.remove();
                            }
                            else
                            {
                                questions.add(question);
                            }
                        }

                        for (Question question : questions)
                        {

                            renderURL.setParameter("uri", question.getURI());
                            actionURL.setParameter("uri", question.getURI());
                            boolean show = false;
                            if ("true".equals(request.getParameter("deleted")))
                            {
                                show = question.getQueStatus() == SWBForumCatResource.STATUS_REMOVED;
                            }
                            else
                            {
                                show = question.getQueStatus() == SWBForumCatResource.STATUS_REGISTERED;
                            }
                            if (show)
                            {
                                i++;
                                String fecha = "";
                                if (question.getCreated() != null)
                                {
                                    fecha = datef.format(question.getCreated());
                                }
                                if (question.getQuestion().length() > 2000)
                                {
                                    question.setQuestion(question.getQuestion().substring(0, 2000));
                                }




    %>
    <li><div class="sfcQuest"><b><%=i%>. Mensaje por aprobar: </b><br/><h3><%=checkHTML(question.getQuestion())%></h3>
            <ul class="sfcInfo">
                <li>De:<%=question.getCreator() != null ? question.getCreator().getFullName() : "Anónimo"%></li>
                <li><%=fecha%></li>
            </ul>
            <%
                                            String text = question.getQuestion();
                                            text = text.replace("&lt;", "<");
                                            text = text.replace("&gt;", ">");
                                            text = text.replace("<em>", "<i>");
                                            text = text.replace("</em>", "</i>");
                                            text = text.replace("<strong>", "<b>");
                                            text = text.replace("</strong>", "</b>");


                                            text = SWBUtils.TEXT.encodeBase64(text);
                                            if ("true".equals(request.getParameter("deleted")))
                                            {
                                                actionURL.setAction("AcceptQuestion");
                                                actionURL.setParameter("cat", cat.getId());
                                                actionURL.setParameter("deleted", "true");
                                                actionURL.setParameter("uri", question.getEncodedURI());

            %>
            <a href="javascript:aproveMsg('<%=actionURL.toString(true)%>','<%=text%>')">Aprobar</a>
            <%
                                                            actionURL.setAction("removeQuestion");
                                                            actionURL.setParameter("cat", cat.getId());
                                                            actionURL.setParameter("deleted", "true");
                                                            //actionURL.setParameter("org", "moderate");
                                                            actionURL.setParameter("uri", question.getEncodedURI());

            %>

            <a href="javascript:deleteMsg('<%=actionURL.toString(true)%>','<%=text%>')">Eliminar</a><br/><br/>

            <%
                                                        }
                                                        else
                                                        {
                                                            actionURL.setAction("AcceptQuestion");
                                                            actionURL.setParameter("cat", cat.getId());
                                                            actionURL.setParameter("deleted", "false");
                                                            actionURL.setParameter("uri", question.getEncodedURI());
            %>
            <a href="javascript:aproveMsg('<%=actionURL.toString(true)%>','<%=text%>')">Aprobar</a>
            <%
                                                                        actionURL.setAction("RejectQuestion");
                                                                        actionURL.setParameter("cat", cat.getId());
                                                                        actionURL.setParameter("deleted", "false");
                                                                        actionURL.setParameter("uri", question.getEncodedURI());
            %>
            <a href="javascript:rejectMsg2('<%=actionURL.toString(true)%>','<%=text%>')">Rechazar</a><br/><br/>
            <%
                                            }
            %>


        </div>
    </li>

    <%
                                    notEmpty = true;
                                }
                                quesHeader = false;
                                Iterator<Answer> itAnswers = question.listAnswerInvs();

                                while (itAnswers.hasNext())
                                {
                                    Answer answer = itAnswers.next();
                                    if (answer.getAnswer() == null || answer.getAnswer().trim().length() == 0)
                                    {
                                        answer.remove();
                                        continue;
                                    }
                                    boolean showAns = false;
                                    if ("true".equals(request.getParameter("deleted")))
                                    {
                                        showAns = answer.getAnsStatus() == SWBForumCatResource.STATUS_REMOVED;
                                    }
                                    else
                                    {
                                        showAns = answer.getAnsStatus() == SWBForumCatResource.STATUS_REGISTERED;
                                    }

                                    if (!quesHeader && showAns)
                                    {
                                        String fecha = "";
                                        if (question.getCreated() != null)
                                        {
                                            fecha = datef.format(question.getCreated());
                                        }
                                        String msg = question.getQuestion();
                                        String Msg = "Mensaje original: ";


                                        msg = msg.replace("&lt;", "<");
                                        msg = msg.replace("&gt;", ">");
                                        msg = msg.replace("<em>", "<i>");
                                        msg = msg.replace("</em>", "</i>");
                                        msg = msg.replace("<strong>", "<b>");
                                        msg = msg.replace("</strong>", "</b>");
                                        Msg = Msg + msg;

    %>
    <li>

        <%
                                                notEmpty = true;
                                                quesHeader = true;
        %>

        <ul class="sfcAnsList">
            <%
                                                }
                                                if (answer.getAnsStatus() == SWBForumCatResource.STATUS_REGISTERED)
                                                {
                                                    String fecha = "";
                                                    if (answer.getCreated() != null)
                                                    {
                                                        fecha = datef.format(answer.getCreated());
                                                    }
                                                    i++;
                                                    if (answer.getAnswer().length() > 2000)
                                                    {
                                                        answer.setAnswer(answer.getAnswer().substring(0, 2000));
                                                    }
            %>
            <li><div class="sfcAns"><b><%=i%>. Respuesta por aprobar: </b><br/><h3><%=checkHTML(answer.getAnswer())%></h3>
                    <ul class="sfcInfo">
                        <li>De:<%=answer.getCreator() != null ? answer.getCreator().getFullName() : "Anónimo"%></li>
                        <li><%=fecha%></li>
                    </ul>
                    <%
                                                                        String text = clean(answer.getAnswer(), 35);
                                                                        text = SWBUtils.TEXT.encodeBase64(text);
                                                                        if ("true".equals(request.getParameter("deleted")))
                                                                        {
                                                                            actionURL.setAction("AcceptAnswer");
                                                                            actionURL.setParameter("cat", cat.getId());
                                                                            actionURL.setParameter("uri", answer.getEncodedURI());
                                                                            actionURL.setParameter("deleted", "true");
                    %>
                    <a href="javascript:aproveMsg('<%=actionURL.toString(true)%>','<%=text%>')">Aprobar</a>
                    <%
                                                                                                actionURL.setAction("removeAnswer");
                                                                                                actionURL.setParameter("cat", cat.getId());
                                                                                                actionURL.setParameter("deleted", "true");
                                                                                                //actionURL.setParameter("org", "moderate");
                                                                                                actionURL.setParameter("uri", answer.getEncodedURI());
                    %>

                    <a href="javascript:deleteMsg('<%=actionURL.toString(true)%>','<%=text%>')">Eliminar</a><br/><br/>
                    <%

                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                actionURL.setAction("AcceptAnswer");
                                                                                                actionURL.setParameter("uri", answer.getURI());
                                                                                                actionURL.setParameter("deleted", "false");
                                                                                                actionURL.setParameter("uri", answer.getEncodedURI());
                    %>
                    <a href="javascript:aproveMsg('<%=actionURL.toString(true)%>','<%=text%>')">Aprobar</a>


                    <%
                                                                                                                    actionURL.setAction("RejectAnswer");
                                                                                                                    actionURL.setParameter("cat", cat.getId());
                                                                                                                    actionURL.setParameter("deleted", "false");
                                                                                                                    actionURL.setParameter("uri", answer.getEncodedURI());
                    %>
                    <a href="javascript:rejectMsg2('<%=actionURL.toString(true)%>','<%=text%>')">Rechazar</a><br/><br/>
                    <%
                                                                        }
                    %>




                </div>
            </li>
            <%
                                                }
                                                if (!itAnswers.hasNext() && quesHeader)
                                                {
            %>
        </ul>
    </li>
    <%              }
                            }
                        }
    %>
</ul>
<%
                }
                if (!notEmpty)
                {


                    String urlhome = paramRequest.getWebPage().getUrl();
%>
No existen preguntas, ni respuestas para moderar.
<%-- <a href="<%=urlhome%>">Ir al inicio</a> --%>
<% }
                else
                {
%>
<br/><br/><a class="liga_icon" href="<%=paramRequest.getRenderUrl()%>">Regresar</a>
<%
                }
            }
%>
<script type="text/javascript">
    function validateRemove(url) {
        if(confirm('¿Esta seguro de borrar el elemento?')) {
            window.location.href=url;
        }
    }
</script>



<%
            boolean showResumen = false;
            if (action != null && action.equals("edit") && request.getParameter("cat") == null)
            {
                showResumen = true;
            }
            if (!showResumen)
            {
                if (request.getParameter("cat") != null && paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat")) != null)
                {
                    WebPage cat = paramRequest.getWebPage().getWebSite().getWebPage(request.getParameter("cat"));
                    Iterator<Question> it = Question.ClassMgr.listQuestionByWebpage(cat);
                    while (it.hasNext())
                    {
                        Question q = it.next();
                    }
%>

<%                                                                        }

            }
            else
            {
%>
<div id="foro">
    <%
                    SWBResourceURL addTema = paramRequest.getRenderUrl();
                    addTema.setAction("showAdd");
                    if (user.isSigned())
                    {
    %>
    <p align="right"><a href="<%=addTema%>">Agregar Tema</a></p>
    <%
                    }
    %>

    <!--<h3>Foros de discusión</h3> -->
    <script type="text/javascript">
        function replaceAll( text, busca, reemplaza ){
            while (text.toString().indexOf(busca) != -1)
                text = text.toString().replace(busca,reemplaza);
            return text;
        }
        function eliminaTema(title,url)
        {
            if(confirm('¿Desea borrar el tema '+title+'?'))
            {
                var str=url;
                var n=replaceAll(str,' ','%');
                
                document.location=n;
            }
        }
    </script>
    <table border="0" cellspacing="0" cellpadding="0">
        <tr>
            <th colspan="3">Temas existentes en el foro</th>
            <th>Último mensaje</th>
            <th colspan="2">Creado por</th>
            <%
                            if (isAdmin)
                            {
            %>
            <th>Acción</th>
            <%                }
            %>
        </tr>
        <%
                        String pid = semanticBase.getProperty(SWBForumCatResource.forumCat_idCatPage, paramRequest.getWebPage().getId());
                        WebPage wpp = paramRequest.getWebPage().getWebSite().getWebPage(pid);
                        if (wpp != null)
                        {
                            String _lang = "es";
                            if (paramRequest.getUser().getLanguage() != null)
                            {
                                _lang = paramRequest.getUser().getLanguage();
                            }

                            Iterator<WebPage> childs = SWBComparator.sortByDisplayName(wpp.listChilds(_lang, true, false, false, true), _lang);

                            while (childs.hasNext())
                            {

                                WebPage child = childs.next();
                                SWBResourceURL url = paramRequest.getRenderUrl();
                                url.setParameter("cat", child.getId());
                                int total = 0;
                                int totalxaccept = 0;
                                int totalremoved = 0;
                                String lasTest = null;
                                Date lastDate = null;
                                String creator = "";
                                Iterator<Question> it = Question.ClassMgr.listQuestionByWebpage(child);
                                it = SWBComparator.sortByCreated(it, false);
                                while (it.hasNext())
                                {
                                    Question q = it.next();


                                    /*if (q.getQueStatus() == SWBForumCatResource.STATUS_ACEPTED)
                                    {*/
                                    if (lastDate == null)
                                    {
                                        lastDate = q.getCreated();
                                        if (q.isAnonymous())
                                        {
                                            creator = "Anónimo";
                                        }
                                        else
                                        {
                                            creator = q.getCreator().getFullName();
                                        }
                                        lasTest = q.getQuestion();

                                    }
                                    else
                                    {
                                        if (q.getCreated() != null && q.getCreated().after(lastDate))
                                        {
                                            if (q.isAnonymous())
                                            {
                                                creator = "Anónimo";
                                            }
                                            else
                                            {
                                                creator = q.getCreator().getFullName();
                                            }
                                            lasTest = q.getQuestion();
                                        }

                                    }
                                    Iterator<Answer> respuestas = q.listAnswerInvs();
                                    while (respuestas.hasNext())
                                    {
                                        Answer respuesta = respuestas.next();
                                        /*if (lastDate != null && respuesta.getAnswer() != null && respuesta.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                                        if (lastDate != null && respuesta.getAnswer() != null)
                                        {
                                            if (respuesta.getCreated() != null && respuesta.getCreated().after(lastDate))
                                            {
                                                lasTest = "Re: " + respuesta.getAnswer();
                                                lastDate = respuesta.getCreated();
                                                if (respuesta.isAnonymous())
                                                {
                                                    creator = "Anónimo";
                                                }
                                                else
                                                {
                                                    creator = respuesta.getCreator().getFullName();
                                                }
                                            }
                                            //total++;
                                        }
                                        /*else if (lastDate == null && respuesta.getAnswer() != null && respuesta.getAnsStatus() == SWBForumCatResource.STATUS_ACEPTED)*/
                                        else if (lastDate == null && respuesta.getAnswer() != null)
                                        {
                                            lasTest = "Re: " + respuesta.getAnswer();
                                            lastDate = respuesta.getCreated();
                                            if (respuesta.isAnonymous())
                                            {
                                                creator = "Anónimo";
                                            }
                                            else
                                            {
                                                creator = respuesta.getCreator().getFullName();
                                            }
                                            //total++;
                                        }
                                        if (respuesta.getAnsStatus() == SWBForumCatResource.STATUS_REMOVED)
                                        {
                                            totalremoved++;
                                        }
                                        if (respuesta.getAnsStatus() == SWBForumCatResource.STATUS_REGISTERED)
                                        {
                                            totalxaccept++;
                                        }

                                    }
                                    total++;
                                    /*}*/
                                    /*else if (q.getQueStatus() == SWBForumCatResource.STATUS_REGISTERED)
                                    {
                                    totalxaccept++;
                                    }
                                    else
                                    {
                                    totalremoved++;
                                    }*/
                                }
                                String categoryName = child.getTitle();
                                String description = "";
                                if (child.getDescription() != null)
                                {
                                    description = child.getDescription();
                                }
                                String idTema = child.getId();
                                String title = child.getTitle();
                                title = title.replace('\"', ' ');
                                title = title.replace('\'', ' ').trim();
                                SWBResourceURL deleteTema = paramRequest.getRenderUrl();
                                deleteTema.setAction("deleteTema");
                                deleteTema.setParameter("idTema", idTema);
                                String urlDeleteTema = deleteTema.toString();
                                urlDeleteTema = urlDeleteTema.replace('%', ' ');

        %>
        <tr>
            <td><%--<img src="<%=defaultbaseimg%>ico_conversacion.gif" alt="Icono de conversación" />--%></td>
            <td class="tema_foro"><strong><a href="<%=url%>"><%=categoryName%></a></strong>
                <%
                                                if (child.getDescription() != null)
                                                {
                %>
                <%=description%>
                <%
                                                }
                %>
            </td>

            <td><a href="<%=url%>">Mensajes: <%=numerosformat.format(total)%></a>
                <%
                                                if (isAdmin)
                                                {
                                                    SWBResourceURL moderate = paramRequest.getRenderUrl();
                                                    //moderate.setAction("moderate");
                                                    moderate.setParameter("cat", child.getId());
                %>
                <%--<br/><a href="<%=moderate%>">Por autorizar: <%=numerosformat.format(totalxaccept)%></a>--%>
                <%
                                                                    moderate.setParameter("deleted", "true");
                %>
                <%--<br/><a href="<%=moderate.toString(true)%>">No autorizados: <%=numerosformat.format(totalremoved)%></a>--%>
                <%
                                                }
                %>

            </td>
            <td colspan="2">
                <%
                                                if (lasTest != null)
                                                {
                                                    lasTest = cleanUltimo(lasTest);
                                                    if (lasTest.length() > 35)
                                                    {
                                                        lasTest = lasTest.substring(0, 35) + " ...";
                                                    }
                                                    String date = "";
                                                    if (lastDate != null)
                                                    {
                                                        date = datef.format(lastDate);
                                                    }
                %>
                <strong><%=lasTest%></strong><br />
                <%=creator%><br />
                <%=date%>
                <%
                                                                }
                                                                else
                                                                {
                %>
                No hay mensajes publicados
                <%                                                                    }
                %>
            </td>
            <td>
                <%
                                                String creador = "";
                                                if (child.getCreator() != null)
                                                {
                                                    creador = child.getCreator().getFullName();
                                                }
                %>
                <%=creador%>
            </td>
            <%
                                            //boolean canDelete = child.getCreator() != null && child.getCreator().getId().equals(user.getId());
                                            if (isAdmin)
                                            {
            %>

            <td><a href="javascript:eliminaTema('<%=title%>','<%=urlDeleteTema%>')">Borrar</a></td>
            <%
                                                        }
                                                        else
                                                        {
            %>
            <td>&nbsp;</td>
            <%                                                                                    }
            %>

        </tr>
        <%
                            }
                        }
        %>



    </table>


    <%
                }
    %>



