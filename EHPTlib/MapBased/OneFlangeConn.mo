within EHPTlib.MapBased;
model OneFlangeConn
   extends Partial.PartialOneFlange;
  Modelica.Blocks.Sources.RealExpression mechPow(y=powSensor.power)   annotation (
    Placement(transformation(extent={{34,-74},{14,-54}})));
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent={{-20,-58},{20,-98}},       rotation = 0), iconTransformation(extent={{70,-58},
            {110,-98}},                                                                                                                             rotation = 0)));
equation
  connect(variableLimiter.u, conn.genTauRef) annotation (Line(points={{-26,30},
          {0,30},{0,-78}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mechPow.y, conn.genPowDel) annotation (Line(points={{13,-64},{6,-64},
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
annotation(
    Documentation(info = "<html><head></head><body>This is a simple variation of OneFlange, which receives the reference torque from the outside through a connector instead of a Real input. It outputs through the same connector the internally computed&nbsp;generated mechanical power.</body></html>"));
end OneFlangeConn;
