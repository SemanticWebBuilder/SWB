org.semanticwb.platform.SemanticProperty sp=org.semanticwb.SWBPlatform.getSemanticMgr().getModel(
    org.semanticwb.SWBPlatform.getSemanticMgr().SWBAdmin).getSemanticProperty(org.semanticwb.SWBPlatform.getSemanticMgr().SWBAdminURI + "/PublicKey");
String pub=org.semanticwb.SWBPlatform.getSemanticMgr().getModel(
    org.semanticwb.SWBPlatform.getSemanticMgr().SWBAdmin).getModelObject().getProperty(sp);
println(pub);