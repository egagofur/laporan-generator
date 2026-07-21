from manim import *

config.frame_width = 8
config.frame_height = 8

class PinwheelLogo(Scene):
    """
    Rekonstruksi logo: 4 segitiga (sudut membulat) tersusun menyilang
    kayak kincir angin, dengan gap kecil & rapat di tengah,
    lalu diputar terus-menerus.
    """

    def construct(self):
        # Background putih biar mirip logo aslinya
        self.camera.background_color = WHITE

        # 1 "bilah" segitiga: apex (ujung lancip) MEPET ke pusat,
        # base (sisi lebar) di luar.
        def make_blade():
            triangle = Polygon(
                [-1.55, 3.0, 0],   # sudut kiri (base)
                [ 1.55, 3.0, 0],   # sudut kanan (base)
                [ 0.00, 0.18, 0],  # ujung (apex) -> DEKAT pusat, gap tipis
                color=BLACK,
                fill_color=BLACK,
                fill_opacity=1,
                stroke_width=0,
            )
            triangle.round_corners(radius=0.15)  # sudut membulat kayak di logo
            return triangle

        blade = make_blade()

        # Gandakan jadi 4, tiap satu diputar 90 derajat -> pola kincir/salib
        pinwheel = VGroup(
            *[blade.copy().rotate(angle, about_point=ORIGIN)
              for angle in [0, PI / 2, PI, 3 * PI / 2]]
        )
        pinwheel.move_to(ORIGIN)

        self.add(pinwheel)

        # Rotasi terus-menerus, kecepatan "standar":
        # 1 putaran penuh (360°) tiap 6 detik
        ROTATION_PERIOD = 6
        pinwheel.add_updater(
            lambda m, dt: m.rotate(dt * (TAU / ROTATION_PERIOD), about_point=ORIGIN)
        )

        self.wait(12)
