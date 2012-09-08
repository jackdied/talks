NAME=talk
python rst-directive.py \
    --stylesheet=pygments.css \
    --theme-url=ui/default \
    ${NAME}.rst > ${NAME}.html
