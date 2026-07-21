from manim import *

config.frame_width = 8
config.frame_height = 8

class PinwheelLogo(Scene):
    def construct(self):
        self.camera.background_color = WHITE

        def make_blade():
            triangle = Polygon(
                [-1.55, 3.0, 0],
                [ 1.55, 3.0, 0],
                [ 0.00, 0.18, 0],
                color=BLACK,
                fill_color=BLACK,
                fill_opacity=1,
                stroke_width=0,
            )
            triangle.round_corners(radius=0.15)
            return triangle

        blade = make_blade()

        pinwheel = VGroup(
            *[blade.copy().rotate(angle, about_point=ORIGIN)
              for angle in [0, PI / 2, PI, 3 * PI / 2]]
        )
        pinwheel.move_to(ORIGIN)

        self.add(pinwheel)

        ROTATION_PERIOD = 6
        pinwheel.add_updater(
            lambda m, dt: m.rotate(dt * (TAU / ROTATION_PERIOD), about_point=ORIGIN)
        )

        self.wait(12)
