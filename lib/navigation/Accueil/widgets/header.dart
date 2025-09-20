import 'package:flutter/material.dart';

class ProfessionalHeader extends StatefulWidget {
  final TabController? tabController;
  final ValueChanged<int>? onTabChanged;

  const ProfessionalHeader({
    super.key,
    this.tabController,
    this.onTabChanged,
  });

  @override
  State<ProfessionalHeader> createState() => _ProfessionalHeaderState();
}

class _ProfessionalHeaderState extends State<ProfessionalHeader>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController ??
        TabController(
          length: 2,
          vsync: this,
        );
    
    if (widget.onTabChanged != null) {
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          widget.onTabChanged!(_tabController.index);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.tabController == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(199, 221, 220, 221),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Première rangée: barre de recherche et boutons
          Row(
            children: [
              // Barre de recherche
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF0B1340), size: 30),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lieu ou N° Centris',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Bouton filtre
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF0B1340), size: 20),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              // Bouton options
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_horiz, color: Color(0xFF0B1340), size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Deuxième rangée: onglets et compteur
          Row(
          
            children: [
             
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                ),
                child: TabBar(
                  dividerHeight: 0,
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color(0xFF0B1340),
                  unselectedLabelColor: const Color.fromARGB(169, 11, 19, 64),
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 3.0,
                      color: Color(0xFF0B1340),
                    ),
                    insets: EdgeInsets.only(bottom: -1.0), // Coller l'indicator au bas
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'Carte'),
                    Tab(text: 'Liste'),
                  ],
                ),
              ),
              const Spacer(),
              // Compteur de propriétés
              const Text(
                '3798 propriétés',
                style: TextStyle(
                  color: Color(0xFF0B1340),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
       
        ],
      ),
    );
  }
}