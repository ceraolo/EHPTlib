within EHPTlib.MapBased;
model Genset "GenSet GMS+GEN+SEngine"
  extends Partial.PartialGenset;
  ECUs.GMS myGMS(
    mapsFileName=mapsFileName,
    nomTorque=actualTauMax,
    nomSpeed=actualSpeedMax) annotation (
    Placement(transformation(extent={{-70,12},{-50,32}})));
equation
  connect(myGMS.Wmecc, gain1.y) annotation (Line(points={{-59.9,10.5},{-60,10},
          {-60,-1.4}}, color={0,0,127}));
  connect(myGMS.tRef, gain.u) annotation (Line(points={{-49,28},{-38,28},{-38,
          40},{-16,40}}, color={0,0,127}));
  connect(myGMS.throttle, iceT.nTauRef) annotation (Line(points={{-49,16},{-44,
          16},{-44,-8},{-30,-8},{-30,-2.22}}, color={0,0,127}));
  connect(myGMS.pRef, limiter.y)
    annotation (Line(points={{-72,22},{-80,22},{-80,43}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Generator set containing Internal Combustion Engine (ICE), electric generator (with DC output), and the related control.</p>
<p>The control logic tends to deliver at the DC port the input power, using the optimal generator speed.</p>
<p>Parameters maxTau, maxPow and maxGenW in Parameters dialog box refer in general to the internal generator, not the engine.</p>
<p>The model needs several ICE-related matrices to be loaded from the input txt file:</p>
<p>1. maxIceTau, containing the maximum torque the ICE can deliver at the various torques</p>
<p>2. specificCons containing the specific consumption of ICE (g/kWh)</p>
<p>3. optiSpeed containing the optimal speed for the maximum efficiency at any ICE mechanical power </p>
<p>It also needs the following generator-related matrix:</p>
<p>1. gensetDriveEffTable containing the efficiency of the electric generator connected to the ICE output </p>
<p>As a target, the library should allow all the matrices read from files to be expressed with inputs with their dimensions (Nm for torques, rad/s for speeds) or in per unit (0-1 values)</p>
<p>At the current stage of development, however:</p>
<ul>
<li>in case useNormalisedFuelMaps=true, maxTauNorm, and maxSpeedNorm are used as max values for the fuel consumption map. This way, larger or smaller engines can be simulated just changing them: leaving the consumption map invaried will keep that maps&apos;s shape unchanged.</li>
<li>In case useNormalisedfuelMaps=false, when maxTorque and/or maxPower and/or maxGenW are changed, the fuel consumption map must be changed accordingly.</li>
</ul>
<h4>Other matrices different from ICE fuel are not normalised (yet).</h4>
</html>"));
end Genset;
