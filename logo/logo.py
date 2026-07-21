from manim import *

# --- Setting canvas rasio 1:1 (persegi) ---
config.pixel_width = 1080
config.pixel_height = 1080
config.frame_width = 8
config.frame_height = 8


def make_blade():
    """1 bilah segitiga: apex (ujung lancip) mepet ke pusat,
    base (sisi lebar) di luar, sudut membulat."""
    triangle = Polygon(
        [-1.55, 3.0, 0],   # sudut kiri (base)
        [ 1.55, 3.0, 0],   # sudut kanan (base)
        [ 0.00, 0.18, 0],  # ujung (apex) -> dekat pusat, gap tipis
        color=BLACK,
        fill_color=BLACK,
        fill_opacity=1,
        stroke_width=0,
    )
    triangle.round_corners(radius=0.15)
    return triangle


def make_pinwheel():
    blade = make_blade()
    pinwheel = VGroup(
        *[blade.copy().rotate(angle, about_point=ORIGIN)
          for angle in [0, PI / 2, PI, 3 * PI / 2]]
    )
    pinwheel.move_to(ORIGIN)
    return pinwheel


class PinwheelLogoStatic(Scene):
    """Logo diam, rasio 1:1 — buat dipakai sebagai gambar/PNG logo."""

    def construct(self):
        self.camera.background_color = WHITE
        pinwheel = make_pinwheel()
        self.add(pinwheel)
        self.wait(0.1)  # render 1 frame aja, cukup buat screenshot/PNG


class PinwheelLogo(Scene):
    """Logo berputar terus kayak kincir angin, rasio 1:1 juga."""

    def construct(self):
        self.camera.background_color = WHITE
        pinwheel = make_pinwheel()
        self.add(pinwheel)

        ROTATION_PERIOD = 6  # detik per 1 putaran penuh
        pinwheel.add_updater(
            lambda m, dt: m.rotate(dt * (TAU / ROTATION_PERIOD), about_point=ORIGIN)
        )
        self.wait(12)
