def partitions(points):
    if len(points) == 1:
        yield [ points ]
        return
    first = points[0]
    for smaller in partitions(points[1:]):
        for m, subset in enumerate(smaller):
            yield smaller[:m] + [[ first ] + subset]  + smaller[m+1:]
        yield [ [ first ] ] + smaller

def nonflat(partition,r):
    p = []
    for j in partition:    
        seq = list(map(lambda x: (x-1)//r,j))
        p.append(len(seq) == len(set(seq)))
    return all(p)

def connected(partition,n,r):
    q = []; c = 0
    if n  == 1: return all([len(j)==1 for j in partition])
    for j in partition:
        jk = list(set(map(lambda x: (x-1)//r,j)))
        if(len(jk)>1):            
            if c == 0:
                q = jk; c += 1
            elif(set(q) & set(jk)):
                d=[y for y in (q+jk) if y not in q]
                q = q + d
    return n == len(set(q))

def connectednonflat(n,r):
    points = list(range(1,n*r+1))
    randd = []
    for m, p in enumerate(partitions(points), 1):
        randd.append(sorted(p))
    for rou in range(r,(r-1)*n+2):    
        rs = [d for d in randd if (nonflat(d,r) and len(d)==rou)]
        rss = [e for e in rs if connected(e,n,r)]
        print("Connected non-flat partitions with",rou,"blocks:",len(rss))
    cnfp = [e for e in randd if (connected(e,n,r) and nonflat(e,r))]
    print("Connected non-flat set partitions:",len(cnfp))
    return cnfp

def graphs(G,EP,setpartition,n):
    r=len(set(flatten(G)));rhoG = []
    for j in range(n):
        for hop in G: rhoG.append([r*j+hop[0],r*j+hop[1]])
        for l in range(len(EP)):
            F=EP[l]
            for i in F: rhoG.append([j*r+i,n*r+l+1]);
    for i in setpartition:
        if(len(i)>1):
            b = []
            for j in rhoG:
                b.append([i[0] if ele in i else ele for ele in j])
            rhoG = b
    for i in rhoG: i.sort()
    return rhoG

def convexhull(n,G,EP):
    r=len(set(flatten(G)));m=len(EP)
    cnfp=connectednonflat(n,r)
    L=[]
    le=sum(len(EP[j]) for j in range(len(EP)))
    for setpartition in cnfp: 
        rhoG=graphs(G,EP,setpartition,n)
        edgesrhoG = [i for n, i in enumerate(rhoG) if i not in rhoG[:n]]
        vertrhoG = set(flatten(edgesrhoG));
        L.append((n*r-(len(vertrhoG)-m),n*(len(G)+le)-len(edgesrhoG)))
    return sorted(set(L))

# Example 5.2

G = [[1,2],[2,3],[3,1]]; EP = []; 

# Figure 4-a)
SG3=convexhull(3,G,EP);
Polyhedron(SG3).plot(color = "pink")+point(SG3,color = "blue",size=20)
# Figure 4-b)
SG4=convexhull(4,G,EP)
Polyhedron(SG4).plot(color = "pink")+point(SG4,color = "blue",size=20)

# Example 5.3

G = [[1,2],[2,3],[3,4],[4,1]]; EP = [];

# Figure 5-a)
SG2=convexhull(2,G,EP);
Polyhedron(SG2).plot(color = "pink")+point(SG2,color = "blue",size=20)
# Figure 5-b)
SG3=convexhull(3,G,EP)
Polyhedron(SG3).plot(color = "pink")+point(SG3,color = "blue",size=20)

# Example 5.4

G = [[1,2],[2,3]]; EP = [[1,3]]; 

# Figure 6-a)
SG3=convexhull(3,G,EP);
Polyhedron(SG3).plot(color = "pink")+point(SG3,color = "blue",size=20)
# Figure 6-a)
SG4=convexhull(4,G,EP)
Polyhedron(SG4).plot(color = "pink")+point(SG4,color = "blue",size=20)
