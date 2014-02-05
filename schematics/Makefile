PCBNAME=FILENAME


all: clean build

clean:
        rm -rf *final* production
build:
        mkdir production
        cp ../meatstand_common/schematics/production_gafrc production/gafrc
        sed s/FILENAME/pig/g ../meatstand_common/schematics/production_Makefile > production/Makefile
        cp ../meatstand_common/schematics/production_readme.txt production/README.txt
        cp $(PCBNAME).sch production/$(PCBNAME).sch
        refdes_renum --gentle production/$(PCBNAME).sch
        gsch2pcb -v -v   --elements-dir ./../meatstand_common/geda-common/pcb-elements production/$(PCBNAME).sch
        ../meatstand_common/schematics/vfont.sh $(PCBNAME)
        ../meatstand_common/schematics/net2pcb.sh $(PCBNAME)

