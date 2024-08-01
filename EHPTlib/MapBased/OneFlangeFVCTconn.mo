within EHPTlib.MapBased;
model OneFlangeFVCTconn
   extends Partial.PartialOneFlangeFVCT;
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent={{-20,-58},{20,-98}},       rotation = 0), iconTransformation(extent={{70,-58},
            {110,-98}},                                                                                                                             rotation = 0)));
  Modelica.Blocks.Sources.RealExpression mechPow(y=powSensor.power)   annotation (
    Placement(transformation(extent={{34,-60},{14,-40}})));
equation
  connect(variableLimiter.u, conn.genTauRef) annotation (Line(points={{-14,30},
          {0,30},{0,-78}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mechPow.y, conn.genPowDel) annotation (Line(points={{13,-50},{6,-50},
          {6,-78},{0,-78}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(wSensor.w, conn.genW) annotation (Line(points={{84,35.2},{84,-78},{0,
          -78}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end OneFlangeFVCTconn;
