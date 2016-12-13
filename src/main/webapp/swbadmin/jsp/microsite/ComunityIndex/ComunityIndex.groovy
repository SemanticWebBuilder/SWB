/**
 * SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integración,
 * colaboración y conocimiento, que gracias al uso de tecnología semántica puede generar contextos de
 * información alrededor de algún tema de interés o bien integrar información y aplicaciones de diferentes
 * fuentes, donde a la información se le asigna un significado, de forma que pueda ser interpretada y
 * procesada por personas y/o sistemas, es una creación original del Fondo de Información y Documentación
 * para la Industria INFOTEC, cuyo registro se encuentra actualmente en trámite.
 *
 * INFOTEC pone a su disposición la herramienta SemanticWebBuilder a través de su licenciamiento abierto al público (‘open source’),
 * en virtud del cual, usted podrá usarlo en las mismas condiciones con que INFOTEC lo ha diseñado y puesto a su disposición;
 * aprender de él; distribuirlo a terceros; acceder a su código fuente y modificarlo, y combinarlo o enlazarlo con otro software,
 * todo ello de conformidad con los términos y condiciones de la LICENCIA ABIERTA AL PÚBLICO que otorga INFOTEC para la utilización
 * del SemanticWebBuilder 4.0.
 *
 * INFOTEC no otorga garantía sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni implícita ni explícita,
 * siendo usted completamente responsable de la utilización que le dé y asumiendo la totalidad de los riesgos que puedan derivar
 * de la misma.
 *
 * Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposición la siguiente
 * dirección electrónica:
 *  http://www.semanticwebbuilder.org
 **/

import org.semanticwb.portal.api.*
import org.semanticwb.model.*
import org.semanticwb.portal.community.*
import org.semanticwb.*
import org.semanticwb.platform.*
import java.util.*

//System.out.println "\n\n\n\nComunityIndex\n\n\n\n"
WebPage topic = (WebPage)request.getAttribute("topic")
WebPage Temas = topic.getWebSite().getWebPage("Intereses")
Set<WebPage> temaTree = new TreeSet<MicroSite>(new SWBComparator("es"))
Temas.listChilds().each{
    temaTree.add(it)
}
println "<div id=\"Accordion1\" class=\"Accordion\">"
temaTree.each{
    WebPage tema = (WebPage)it
    if (tema.isValid()){
        Set<MicroSite> localCom = new TreeSet<MicroSite>(new SWBComparator("es"))
        findCommunities(localCom, tema)
        //System.out.println tema
        if (localCom.size()>0){
            
            println """                <div class="AccordionPanel">
                    <div class="AccordionPanelTab AccordionPanelClosed"><a style="color:#D9D9B5; text-decoration:none" href="${tema.getRealUrl()}">${tema.getDisplayName("es")}</a></div>
                    <div class="AccordionPanelContent">
                        <ul class="itemsCategoria">"""
//      	<h2><strong><a href="${tema.getRealUrl()}">${tema.getDisplayName("es")}</a></strong></h2>
//                     <ul class="itemsCategoriaTema">

            localCom.each{
                WebPage curr = (WebPage)it
                User user = it.getCreator()
                println "                  <li><a href=\"${curr.getRealUrl()}\">${curr.getDisplayName("es")},</a> creada por ${user.getFullName()}</li>"
            }
            println "                </ul></div></div>"
        }
    }
}
println """</div>
        <script type="text/javascript">
            var Accordion1 = new Spry.Widget.Accordion("Accordion1");
        </script>"""
//println Temas


//System.out.println "\n\n\n\nComunityIndex\n\n\n\n"



def findCommunities(Set saved, WebPage page){
    page.listChilds().each(){
        if (it.isValid()){
            if (it.getClass().equals(MicroSite.class)){
                saved.add(it)
            } else {
                findCommunities(saved, it)
            }
        }
    }
    page.listWebPageVirtualChilds().each{
        if (it.isValid()){
            if (it.getClass().equals(MicroSite.class)){
                saved.add(it)
            } else {
                findCommunities(saved, it)
            }
        }
    }
}