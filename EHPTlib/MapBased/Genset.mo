within EHPTlib.MapBased;
model Genset "GenSet GMS+GEN+SEngine"
  extends Partial.PartialGenset(gen(effMapOnFile=true));
  ECUs.GMS gms(
    throttlePerWerr=throttlePerWerr,
    mapsFileName=mapsFileName,
    nomTorque=actualTauMax,
    nomSpeed=actualSpeedMax)
    annotation (Placement(transformation(extent={{-70,12},{-50,32}})));
equation
  connect(gms.Wmecc, gain1.y) annotation (Line(points={{-60.1,10.5},{-60,10.5},
          {-60,0},{-80,0},{-80,-17.4}}, color={0,0,127}));
  connect(gms.tRef, gain.u) annotation (Line(points={{-49,28},{-38,28},{-38,34},
          {12,34}}, color={0,0,127}));
  connect(gms.throttle, iceT.nTauRef) annotation (Line(points={{-49,16},{-44,16},
          {-44,-24},{-24,-24},{-24,-20.2}}, color={0,0,127}));
  connect(gms.pRef, limiter.y)
    annotation (Line(points={{-72,22},{-80,22},{-80,37}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Generator set containing Internal Combustion Engine (ICE), electric generator (with DC output), and the related control.</p>
<p>This model models a generator set, as the one present in a series-hybrid vehicle: it contains an Internal Combustion engine (ICE), coupled through an ideal reduction gear (set its ratio to 1 in case it is absent) to an electric generator (with DC output). </p>
<p>It contains also the control logic of this set, that asks the ICE deliver, using the optimal generator speed, the requested input power. Actual DC power will be lower, due to the generator efficiency.</p>
<p>The model needs several ICE-related matrices to be loaded from the input txt file:</p>
<p>1. maxIceTau, containing the maximum torque the ICE can deliver at the various torques</p>
<p>2. specificCons containing the specific consumption of ICE (g/kWh)</p>
<p>3. optiSpeed containing the optimal speed for the maximum efficiency at any ICE mechanical power </p>
<p>It also needs the following generator-related matrix:</p>
<p>1. gensetDriveEffTable containing the efficiency of the electric generator connected to the ICE output </p>
<p>Actual delivered DC power depends, in addition to the generator efficiency, also on limits on  mechanical torque (maxTau) and generator power (maxGenPow).</p>
<p>---------------------------------------------------------------------------------------------------------------------</p>
<p>As a target, the library should allow all the matrices read from files to be expressed with inputs with their dimensions (Nm for torques, rad/s for speeds) or in per unit (0-1 values)</p>
<p>At the current stage of development, however:</p>
<ul>
<li>in case useNormalisedFuelMaps=true, maxTauNorm, and maxSpeedNorm are used as max values for the fuel consumption map. This way, larger or smaller engines can be simulated just changing them: leaving the consumption map invaried will keep that maps&apos;s shape unchanged.</li>
<li>In case useNormalisedfuelMaps=false, when maxTorque and/or maxPower and/or maxGenW are changed, the fuel consumption map must be changed accordingly.</li>
</ul>
<h4>Other matrices different from ICE fuel are not normalised (yet).</h4>
</html>"));
end Genset;
