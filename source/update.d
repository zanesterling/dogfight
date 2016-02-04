module update;

import std.math;

import actor.plane;
import misc.utils;
import state.sim_state;

const double EPSILON = 0.000001;

void update(SimulationState state) {
	foreach (plane; state.planes) {
		plane.pos += plane.vel;

		plane.vel += Plane.ACCELERATION * plane.headingVector;
		if (plane.vel.squaredLength > Plane.MAX_SPEED ^^ 2) {
			// cap at max-speed
			plane.vel = Plane.MAX_SPEED * plane.vel.normalized();
		}

		// update plane heading
		auto headingDiff = (plane.desiredHeading - plane.heading)
			.mod(2 * PI);
		headingDiff -= (headingDiff > PI) ? 2 * PI : 0;
		if (abs(headingDiff) > EPSILON) {
			if (abs(headingDiff) < Plane.HEADING_ROT_SPEED) {
				plane.heading = plane.desiredHeading;
			} else {
				plane.heading += Plane.HEADING_ROT_SPEED *
					(headingDiff > 0 ? 1 : -1);
			}
		}
	}
}
