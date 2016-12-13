<%-- 
    Document   : Tree
    Created on : 6/04/2010, 04:34:45 PM
    Author     : jose.jimenez
    Muestra un �rbol con la estructura jer�rquica de las secciones del sitio a partir
    de aquella que se indique como el nodo ra�z. Por defecto, el nodo ra�z es la secci�n
    en la que se incluye esta JSP como recurso de contenido.
--%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest" %>
<%@page import="org.semanticwb.model.*" %>
<%@page import="java.util.*" %>
<!--DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd"-->
<%
//SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
//WebPage wp = paramRequest.getWebPage();
WebPage wp = ((SWBParamRequest) request.getAttribute("paramRequest")).getWebPage();
%>
<!--html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tree for forum</title-->
        <script type="text/javascript">
        dojo.require("dojo.data.ItemFileWriteStore");
        dojo.require("dijit.Tree");
        dojo.require("dijit.Menu");
        </script>
    <!--/head>
    <body-->
        <div style="float: left;">
            <div title="<%=wp.getTitle()%>">
                <%-- En la siguiente l�nea se debe pasar como par�metro, el URI codificado de la p�gina Web
                     que se vaya a tomar como nodo ra�z en el �rbol. --%>
                <div dojoType="dojo.data.ItemFileWriteStore" jsId="mtreeStore" url="/swbadmin/jsp/forumCat/ItemStoreGenerator.jsp?uri=<%=wp.getEncodedURI()%>"></div>
                <div dojoType="dijit.tree.ForestStoreModel" jsId="mtreeModel" store="mtreeStore" rootId="root" childrenAttrs="children"></div>
                <!-- tree widget -->
                <div dojoType="dijit.Tree" id="mtree" model="mtreeModel" betweenThreshold_="8" persist="false" showRoot="false" dragRestriction="false">
                    <script type="dojo/method" event="onClick" args="item">
                        /**
                         *En esta parte deber� colocarse el c�digo a ejecutar cuando un elemento del �rbol
                         *sea seleccionado.
                         **/
                        //alert("Se ha seleccionado \"" + mtreeStore.getLabel(item) + "\", aqu� se pueden hacer algunas operaciones al seleccionar este elemento.");
                        document.getElementById("categoryuri").value=mtreeStore.getValue(item,"tpurl","error");
                    </script>
                  <script type="text/javascript" >
                      dojo.declare(
      "dijit.Tree",
      dijit.Tree,
{
        _firstNodeExpanded: 0,

       _createTreeNode: function()
       {
                       var r = this.inherited(arguments);

                       if (this._firstNodeExpanded == 0)
                       {
                               this._firstNodeExpanded = 1; // das n�chste Elm aufmachen (root-Node �berspringen)
                       } else if (this._firstNodeExpanded == 1)
                       {
                               this._expandNode(r);
                               this._firstNodeExpanded = 2; // nix mehr machen
                       }
          return r;
       }
});
                    </script>
                  
                </div>
            </div>
        </div>
    <!--/body>
</html-->
