"""Reproducible geometric Bud-E app icon. Requires Pillow."""
from pathlib import Path
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[1]
image = Image.new('RGB', (1024, 1024), '#166556')
d = ImageDraw.Draw(image)
d.rounded_rectangle((240, 280, 784, 715), radius=140, fill='#D4F77D')
d.line((512, 190, 512, 285), fill='#D4F77D', width=28)
d.ellipse((470, 132, 554, 216), fill='#FFD4BC')
d.rounded_rectangle((294, 359, 730, 618), radius=90, fill='#192D34')
for x in [410, 614]:
    d.ellipse((x-29, 425-29, x+29, 425+29), fill='#D4F77D')
d.arc((440, 454, 584, 553), 0, 180, fill='#D4F77D', width=22)
d.rounded_rectangle((175, 394, 225, 557), radius=25, fill='#D4F77D')
d.rounded_rectangle((799, 394, 849, 557), radius=25, fill='#D4F77D')
d.rounded_rectangle((360, 743, 664, 812), radius=34, fill='#D4F77D')
for density, size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    image.resize((size,size), Image.Resampling.LANCZOS).save(root/f'android/app/src/main/res/mipmap-{density}/ic_launcher.png')
image.save(root/'windows/runner/resources/app_icon.ico',sizes=[(16,16),(32,32),(48,48),(64,64),(128,128),(256,256)])
image.resize((32,32),Image.Resampling.LANCZOS).save(root/'web/favicon.png')
for size in [192,512]:
    for prefix in ['Icon-', 'Icon-maskable-']:
        image.resize((size,size),Image.Resampling.LANCZOS).save(root/f'web/icons/{prefix}{size}.png')
image.resize((512,512),Image.Resampling.LANCZOS).save(root/'artifacts/app-icon.png')
