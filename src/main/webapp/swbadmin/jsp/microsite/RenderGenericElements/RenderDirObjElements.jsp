<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!    private static final String VER_COMENTARIOS = "Ver comentarios";
    private static final String OCULTAR_COMENTARIOS = "Ocultar comentarios";
%>
<%
            DirectoryObject mse = (DirectoryObject) request.getAttribute("DirectoryObject");
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            if (paramRequest == null)
            {
                return;
            }
            WebPage webPage = paramRequest.getWebPage();
            User mem = paramRequest.getUser();
            String suri = request.getParameter("uri");
            //String abusedDesc = mse.isAbused() ? "Inapropiado" : "Apropiado";
            //String abusedDesc ="Inapropiado" ;
            int rank = 0;
            long pageNumber = 0;
            boolean showComments = false;

            try
            {
                pageNumber = Long.parseLong(request.getParameter("pn"));
                showComments = true;
            } catch (Exception e)
            {
                pageNumber = 1;
            }

            if (suri == null && this != null)
            {
                suri = mse.getURI();
            }
            //tmpUrl = "uri=\"+escape('" + suri + "')";
            rank = (int) Math.round(Math.floor(mse.getRank()));
            SWBResourceURL url = paramRequest.getActionUrl();
            url.setAction("vote");
            url.setMode(paramRequest.getMode());
            url.setCallMethod(SWBResourceURL.Call_DIRECT);
%>
<script type="text/javascript">
    dojo.require("dojo.parser");
    dojo.require("dojox.form.Rating");
</script>
<script type="text/javascript">
    <!--
    var request = false;
    try {
        request = new XMLHttpRequest();
    } catch (trymicrosoft) {
        try {
            request = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (othermicrosoft) {
            try {
                request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (failed) {
                request = false;
            }
        }
    }
    if (!request)
        alert("Error al inicializar XMLHttpRequest!");
    var invoke = true;
    var count = 0;



    function deletecomment(uri,text,commentId)
    {
        if(confirm('¿Esta seguro de borrar el comentario: '+text+'?'))
        {
            spamId = commentId;
            var uri='<%=suri%>';
            uri=escape(uri);
            var url = '<%=url%>?act=deletecomment&commentId='+ commentId +'&uricomment='+uri;            
            request.open("GET", url, true);
            request.onreadystatechange = deleted;
            request.send(null);
        }
    }
    function deleted() {
            if(request.readyState!=4) return;
            if(request.status==200) {
                var response = request.responseText;
                if ('Not OK'!=response && ''!=response) {
                    window.location.reload(true);
                }
            }
        
    }

    function vote(val) {
        if (count == 0) {
                if (!invoke) return;
                var uri='<%=suri%>';
                uri=escape(uri);
                var url = '<%=url%>?act=vote&value='+escape(val)+'&uri='+uri;
                console.log(url);
                request.open("GET", url, true);
                var obj=dijit.byId("rank_stars");
                obj.onChange=function(){return;};
                obj._onMouse=function(){return;};
                obj.onStarClick=function(){return;};
                count++;
                request.onreadystatechange = ranked;
                request.send(null);
        }

    }

    function ranked() {

            if(request.readyState!=4) return;
            if(request.status==200) {
                var response = request.responseText;
                if ('Not OK'!=response && ''!=response) {
                    var ranking = Math.floor(response.split('|')[0]);
                    var obj=dijit.byId("rank_stars");
                    obj.attr("value",ranking);
                    var votes = response.split('|')[1];                    
                    document.getElementById("reviews").innerHTML = votes;
                    alert('¡Gracias por su voto!');
                    invoke = false;
                } else {
                    alert('Lo sentimos, ha ocurrido un problema al contabilizar la calificación!');
                }
            }

    }
    var invokeAbused = true;

    function changeAbusedState() {
        if (!invokeAbused) return;
        var uri='<%=suri%>';
        uri=escape(uri);
        var url = '<%=url%>?act=abuseReport&uri='+uri;
        request.open("GET", url, true);
        request.onreadystatechange = abusedStateChanged;
        request.send(null);
        document.getElementById("markabused").style.visibility='hidden';

    }

    function refreshAbused() {
        if (!invokeAbused) return;
        var uri='<%=suri%>';
        uri=escape(uri);
        var url = '<%=url%>?act=getAbused&uri='+uri;
        request.open("GET", url, true);
        request.onreadystatechange = refreshAbusedChanged;
        request.send(null);
        document.getElementById("markabused").style.visibility='hidden';
    }

    function refreshAbusedChanged() {
        if (request.readyState != 4) return;
        if (request.status == 200) {
            var response = request.responseText;
       
            if ('' != response)
            {
                document.getElementById("labelabused").innerHTML=response+' veces marcado como inapropiado';
            }
        }
    }

    function abusedStateChanged() {
        if (request.readyState != 4) return;
        if (request.status == 200) {
            var response = request.responseText;
            refreshAbused();
            if ('' != response && 'Not OK' != response) {
                /*var etiqueta = document.getElementById("abused").innerHTML;
                if (response == 'true') {
                    document.getElementById("abused").innerHTML = 'Inapropiado';
                    var divmarkup=document.getElementById("markop");
                    if(divmarkup)
                    {
                        divmarkup.style.display='none';
                    }
                } else {
                    document.getElementById("abused").innerHTML = 'Apropiado';
                }*/
                invokeAbused = false;
            }
        }
    }
    function sendComment()
    {
        document.addCommentForm.submit();
    }
    function addComment() {
        document.getElementById("addComment").style.display="inline";
    }
    function cancelComment() {
        document.getElementById("addComment").style.display="none";
        document.getElementById("comentario").value="";
    }
    function showComments() {
        var x = document.getElementById("commentsList").style.display;
        if (x == 'none') {
            document.getElementById("commentsList").style.display="inline";
            document.getElementById("ctrlComments").innerHTML="<%=OCULTAR_COMENTARIOS%>";
        } else {
            document.getElementById("commentsList").style.display="none";
            document.getElementById("ctrlComments").innerHTML="<%=VER_COMENTARIOS%>";
        }
    }

    var invokeSpam = true;
    var spamId = 0;

    function spam(commentId) {
        spamId = commentId;
        if (!invokeSpam) return;
        var uri='<%=suri%>';
        uri=escape(uri);
        var url = '<%=url%>?act=spamReport&commentId='+commentId+'&uri='+uri;
        request.open("GET", url, true);
        request.onreadystatechange = spamStateChanged;
        request.send(null);
        document.getElementById("divspamMark"+commentId).style.visibility='hidden';
        
    }

    function refreshSpam(commentId) {
        spamId = commentId;
        if (!invokeSpam) return;
        var uri='<%=suri%>';
        uri=escape(uri);
        var url = '<%=url%>?act=getSpam&commentId='+commentId+'&uri='+uri;
        request.open("GET", url, true);
        request.onreadystatechange = getSpamStateChanged;
        request.send(null);
        document.getElementById("divspamMark"+commentId).style.visibility='hidden';

    }

    function getSpamStateChanged() {
        if (request.readyState != 4) return;
        if (request.status == 200) {
            var response = request.responseText;            
            if ('' != response ) {
                document.getElementById("labeldivspamMark"+spamId).innerHTML='<p>'+response +' marcas como spam<'+'/p>';
            }
        }
    }

    function spamStateChanged() {
        if (request.readyState != 4) return;
       
        if (request.status == 200) {
           
            refreshSpam(spamId);
            var response = request.responseText;
            if ('' != response && 'Not OK' != response) {
                var etiqueta = document.getElementById("spamMark"+spamId).innerHTML;
                if (response == 'false') {
                    document.getElementById("spamMark"+spamId).innerHTML = '[marcar como spam]';
                } else {
                    document.getElementById("spamMark"+spamId).innerHTML = '[es spam]';
                }
                invokeSpam = false;
            }
        }
        invokeSpam = true;
    }
    -->
</script>

<div class="common_funcs">

    <div class="rank_label">Calificar:</div>
    <%
            if (mem.isSigned() && request.getSession().getAttribute("vote"+mse.getURI())==null)
            {
    %>
   

    <script type="text/javascript">
        dojo.addOnLoad(function(){
        var props={numStars:5,value:<%=rank%>,onChange:function()
        {
            vote(this.value);
            return;
        }

        };
        var rank_stars=new dojox.form.Rating(props,"rank_stars");        

        });
        </script>
    <div class="rank_stars" id="rank_stars"></div>
    <%
        } else
        {
    %>
    
    <script type="text/javascript">
        dojo.addOnLoad(function(){
        var props={numStars:5,value:<%=rank%>,_onMouse:function()
        {

            return;
        },onStarClick:function(){return;}

        };
        var rank_stars=new dojox.form.Rating(props,"rank_stars");        

        });
        </script>
    <div class="rank_stars" id="rank_stars"></div>
    <%
            }
    %>

    <div class="rec_votes">
        <div class="rec_votes_num" id="reviews"><%=mse.getReviews()%></div>
        <div class="rec_votes_label"> votos</div>
    </div>
    <div  class="rank_label">
        <%
            java.text.DecimalFormat df = new java.text.DecimalFormat("###,###");
            String data = df.format(mse.getAbused());
        %>
        <div id="labelabused"><%=data%> veces marcado como inapropiado</div>
    </div>
    <%

            if (mem.isSigned() && request.getSession().getAttribute(mse.getURI()) == null)
            {
    %>
    <div class="clearL"></div>
    <div id="markop">
        <div id="markabused" class="editarInfo">
            <p>
                <a class="userTool" href="javascript:changeAbusedState();">Marcar como inapropiado</a></p>
        </div>
    </div>
    <%            }
    %>
</div><br/><br/>
<div class="commentBox">
    <!--p-->
    <%
            url.setAction("addComment");
            url.setCallMethod(SWBResourceURL.Call_CONTENT);
            if (mem.isSigned())
            {
    %>
    <a class="userTool" href="javascript:addComment()">Escribir comentario</a>
    <%            }
    %>
    <a class="userTool" id="ctrlComments" href="javascript:showComments();"><%=OCULTAR_COMENTARIOS%></a>
    <!--/p-->
    <%
            url.setAction("addComment");
            url.setCallMethod(SWBResourceURL.Call_CONTENT);
            if (mem.isSigned())
            {
    %>
    <div id="addComment" style="display:none">
        <form name="addCommentForm" id="addCommentForm" action="<%=url%>" method="post">
            <div>
                <label for="comentario">Comentario</label>
                <input type="hidden" name="uri" value="<%=suri%>">
                <input type="hidden" name="act" value="addComment">
                <textarea name="comentario" id="comentario" cols="45" rows="5"></textarea>
            </div>
        </form>

        <a class="userTool" href="javascript:sendComment()">Publicar</a>
        <a class="userTool" href="javascript:cancelComment()">Cancelar</a>

    </div>
    <%
            }
    %>
</div>
<h2>Comentarios</h2>
<%
            request.setAttribute("page", pageNumber);
            request.setAttribute("suri", suri);
%>
<jsp:include flush="true" page="ListDirObjComments.jsp"></jsp:include>
<%
%>
